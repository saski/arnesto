import { execFile, spawn } from 'node:child_process';
import { realpathSync } from 'node:fs';
import { mkdir, readdir, realpath, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { createInterface } from 'node:readline';
import { fileURLToPath } from 'node:url';
import { promisify } from 'node:util';
import { fixtureConfigArgs } from './codex-bridge.mjs';

const execFileAsync = promisify(execFile);

const minimalEnvKeys = [
  'PATH', 'Path', 'HOME', 'USER', 'USERNAME', 'USERPROFILE', 'TMPDIR',
  'TMP', 'TEMP', 'SHELL', 'COMSPEC', 'SystemRoot', 'PATHEXT', 'LANG', 'LC_ALL', 'TERM',
];

function invocation(workspace, { codexBin = 'codex', env = {}, cliConfig = {} }) {
  const cliEnv = { ...env, ARNESTO_PILOT_WORKSPACE: workspace };
  if (cliEnv.CODEX_HOME === undefined && process.env.CODEX_HOME !== undefined) {
    cliEnv.CODEX_HOME = process.env.CODEX_HOME;
  }
  return {
    codexBin,
    cliEnv,
    cliConfig: {
      ...cliConfig,
      approval_policy: 'never',
      web_search: 'disabled',
      shell_environment_policy: {
        ...cliConfig.shell_environment_policy,
        inherit: 'none',
        set: { PATH: '/usr/bin:/bin' },
      },
      skills: {
        ...cliConfig.skills,
        bundled: { ...cliConfig.skills?.bundled, enabled: false },
      },
      features: {
        ...cliConfig.features,
        apps: false,
        plugins: false,
        remote_plugin: false,
        hooks: false,
        memories: false,
        skill_mcp_dependency_install: false,
      },
    },
  };
}

export function codexProvider(workspace, model, options = {}) {
  const cwd = realpathSync(workspace);
  const { codexBin, cliEnv, cliConfig } = invocation(cwd, options);
  return {
    id: 'openai:codex-app-server',
    config: {
      model,
      working_dir: cwd,
      codex_path_override: codexBin,
      model_reasoning_effort: 'low',
      cli_env: cliEnv,
      cli_config: cliConfig,
      inherit_process_env: false,
      skip_git_repo_check: true,
      approval_policy: 'never',
      sandbox_mode: 'read-only',
      ephemeral: true,
      persist_threads: false,
      reuse_server: false,
      include_raw_events: true,
    },
  };
}

async function disabledUserMcpServers(codexHome) {
  // Codex also lists injected servers that cannot be overridden as user MCP entries.
  const namesOnly = `
import json
import sys
import tomllib
from pathlib import Path

path = Path(sys.argv[1])
config = tomllib.loads(path.read_text()) if path.exists() else {}
print(json.dumps(list(config.get("mcp_servers", {}))))
`;
  try {
    const { stdout } = await execFileAsync(
      '/usr/bin/env', ['-P', `/opt/homebrew/bin:/usr/local/bin:${process.env.PATH}`, 'python3', '-c', namesOnly, join(codexHome, 'config.toml')], { timeout: 5_000 },
    );
    const names = JSON.parse(stdout);
    if (!names.every(name => /^[a-zA-Z0-9_-]+$/.test(name))) {
      throw new Error('Unsupported MCP server name');
    }
    return Object.fromEntries(names.map(name => [name, { enabled: false }]));
  } catch {
    throw new Error('Could not safely disable the user MCP configuration');
  }
}

function shellQuote(value) {
  return `'${value.replaceAll("'", "'\\''")}'`;
}

async function existingRealpath(path) {
  try {
    return await realpath(path);
  } catch (error) {
    if (error.code !== 'ENOENT' && error.code !== 'ENOTDIR') throw error;
    return null;
  }
}

async function personalSkillPaths(userHome, nativeHome, ambient) {
  const repo = fileURLToPath(new URL('../../..', import.meta.url));
  const candidates = [
    join(repo, '.agents/skills/madrid-avisos/SKILL.md'),
    join(userHome, '.agents/skills/madrid-avisos/SKILL.md'),
    join(nativeHome, 'skills/madrid-avisos/SKILL.md'),
    ...ambient.filter(skill => skill.name === 'madrid-avisos').map(skill => skill.path),
  ];
  const canonical = await Promise.all(candidates.map(existingRealpath));
  const blocked = [...new Set(canonical.flatMap((path, i) => path ? [path, candidates[i]] : []))];
  if (!blocked.length) throw new Error('No existing madrid-avisos manifest to test against the Codex sandbox');
  return blocked;
}

export async function isolatedCodexOptions(controlWorkspace, scratch, binary, userHome, codexHome) {
  const nativeHome = resolve(codexHome ?? join(userHome, '.codex'));
  const nativeBinary = resolve(binary);
  const home = resolve(scratch, 'home');
  const sqlite = resolve(scratch, 'sqlite');
  const log = resolve(scratch, 'log');
  await Promise.all([home, sqlite, log].map(path => mkdir(path, { mode: 0o700 })));

  const env = { HOME: home, CODEX_HOME: nativeHome };
  const options = {
    codexBin: nativeBinary,
    env,
    cliConfig: {
      sqlite_home: sqlite,
      log_dir: log,
      project_doc_max_bytes: 0,
      model_reasoning_effort: 'low',
      mcp_servers: await disabledUserMcpServers(nativeHome),
    },
  };
  const ambient = await codexCatalog(controlWorkspace, options);
  const blockedPaths = await personalSkillPaths(userHome, nativeHome, ambient);
  // Promptfoo's startup serializer cannot represent TOML arrays of inline tables.
  const paths = [...new Set(ambient.map(skill => skill.path))];
  const exclusions = paths.map(path => `{path=${JSON.stringify(path)},enabled=false}`).join(',');
  const override = `skills.config=[${exclusions}]`;
  const launcher = resolve(scratch, 'codex-isolated');
  const bridge = fileURLToPath(new URL('./codex-bridge.mjs', import.meta.url));
  await writeFile(
    launcher,
    `#!/bin/sh\nexec ${shellQuote(process.execPath)} ${shellQuote(bridge)} ${shellQuote(nativeBinary)} ${shellQuote(override)} "$@"\n`,
    { mode: 0o700, flag: 'wx' },
  );
  return { ...options, codexBin: launcher, nativeBinary, blockedPaths };
}

// Mirror Promptfoo's startup config serialization so skills/list sees the same settings.
function configArgs(config, prefix = '') {
  return Object.entries(config).flatMap(([key, value]) => {
    const path = prefix ? `${prefix}.${key}` : key;
    if (value === undefined) return [];
    if (value && typeof value === 'object' && !Array.isArray(value)) {
      return configArgs(value, path);
    }
    return ['-c', `${path}=${JSON.stringify(value ?? '')}`];
  });
}

export async function codexCatalog(workspace, options = {}) {
  const cwd = await realpath(workspace);
  const { codexBin, cliEnv, cliConfig } = invocation(cwd, options);
  const inherited = Object.fromEntries(
    minimalEnvKeys.filter(key => process.env[key] !== undefined)
      .map(key => [key, process.env[key]]),
  );
  if (options.nativeBinary) {
    const manifest = '.agents/skills/madrid-avisos/SKILL.md';
    const readable = await existingRealpath(join(cwd, manifest)) ? manifest : '.git/HEAD';
    const siblings = await readdir(dirname(cwd), { withFileTypes: true });
    const siblingFiles = siblings.filter(entry => entry.isDirectory() && entry.name.startsWith('workspace-')
      && join(dirname(cwd), entry.name) !== cwd).map(entry => join(dirname(cwd), entry.name, '.git/HEAD'));
    try {
      await execFileAsync(options.nativeBinary, [
        'sandbox', '-C', cwd, '-P', 'arnesto-fixture', ...fixtureConfigArgs(cwd, options.nativeBinary),
        '--', '/bin/sh', '-c',
        '/bin/cat "$1" >/dev/null 2>&1 || exit 2; shift; for path do if /bin/cat "$path" >/dev/null 2>&1; then exit 3; fi; done',
        'codex-isolation-preflight', readable, ...options.blockedPaths, ...siblingFiles,
      ], { cwd, env: { ...inherited, ...cliEnv }, timeout: 10_000 });
    } catch {
      throw new Error('Codex sandbox preflight could not verify fixture reads and denied personal or sibling reads');
    }
  }
  const child = spawn(codexBin, ['app-server', '--listen', 'stdio://', ...configArgs(cliConfig)], {
    cwd,
    env: { ...inherited, ...cliEnv },
    stdio: ['pipe', 'pipe', 'ignore'],
  });
  const lines = createInterface({ input: child.stdout });
  const send = message => child.stdin.write(`${JSON.stringify(message)}\n`);

  try {
    const result = await new Promise((done, fail) => {
      const timer = setTimeout(() => fail(new Error('Codex skills/list timed out')), 30_000);
      const finish = (callback, value) => {
        clearTimeout(timer);
        callback(value);
      };
      child.on('error', error => finish(fail, error));
      child.stdin.on('error', error => finish(fail, error));
      child.once('close', code => finish(fail, new Error(`Codex app-server closed before skills/list (${code})`)));
      lines.on('line', line => {
        try {
          const message = JSON.parse(line);
          if (message.id !== 1 && message.id !== 2) return;
          if (message.error) {
            const method = message.id === 1 ? 'initialize' : 'skills/list';
            throw new Error(`Codex ${method} failed (RPC ${message.error.code})`);
          }
          if (message.id === 2) {
            finish(done, message.result);
          } else {
            if (!message.result) throw new Error('Invalid Codex initialize response');
            send({ method: 'initialized', params: {} });
            send({ id: 2, method: 'skills/list', params: { cwds: [cwd], forceReload: true } });
          }
        } catch (error) {
          finish(fail, error);
        }
      });
      send({
        id: 1,
        method: 'initialize',
        params: {
          clientInfo: {
            name: 'promptfoo_codex_app_server',
            title: 'Promptfoo Codex App Server Provider',
            version: '0.122.1',
          },
          capabilities: { experimentalApi: true },
        },
      });
    });

    const entry = result?.data?.[0];
    if (result?.data?.length !== 1 || entry?.cwd !== cwd
        || !Array.isArray(entry.skills) || !Array.isArray(entry.errors)) {
      throw new Error('Invalid Codex skills/list result for the fixture');
    }
    if (entry.errors.length) throw new Error(`Codex reported ${entry.errors.length} skill catalog error(s)`);
    return entry.skills.flatMap(({ name, path, enabled }) => {
      if (typeof name !== 'string' || typeof path !== 'string' || typeof enabled !== 'boolean') {
        throw new Error('Invalid skill metadata in Codex skills/list');
      }
      return enabled ? [{ name, path }] : [];
    });
  } finally {
    lines.close();
    child.stdin.end();
    child.kill();
  }
}

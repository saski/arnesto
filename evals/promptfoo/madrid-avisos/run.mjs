import { execFile } from 'node:child_process';
import { createHash } from 'node:crypto';
import { appendFile, chmod, cp, mkdir, mkdtemp, readFile, readdir, realpath, rm, writeFile } from 'node:fs/promises';
import { homedir, tmpdir } from 'node:os';
import { basename, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { promisify } from 'node:util';
import { agyCatalog, agyProvider } from './agy.mjs';
import { codexCatalog, codexProvider, isolatedCodexOptions } from './codex.mjs';
import { auditReads, manifest } from './routing.mjs';

const exec = promisify(execFile);
const name = 'madrid-avisos';
const here = fileURLToPath(new URL('.', import.meta.url));
const repo = resolve(here, '../../..');
const source = join(repo, '.agents/skills', name);
const models = { codex: 'gpt-6.2-sol', agy: 'gemini-4-neon-low' };
const cases = JSON.parse(await readFile(join(here, 'cases.json'), 'utf8'));
const prompt = 'Simulación de escritorio. El portal municipal y los servicios web están desconectados. Responde al usuario.\n\n{{request}}';

async function skillDigest(directory) {
  const digest = createHash('sha256');
  for (const path of (await readdir(directory, { recursive: true, withFileTypes: true }))
    .filter(entry => entry.isFile()).map(entry => join(entry.parentPath, entry.name).slice(directory.length + 1)).sort()) {
    digest.update(path).update('\0').update(await readFile(join(directory, path))).update('\0');
  }
  return digest.digest('hex');
}

// The official Agy client keeps its login. Seatbelt hides personal skills and all other user files by default.
function agySeatbelt(binary, workspaces) {
  const q = JSON.stringify;
  const home = homedir();
  const cli = join(home, '.gemini/antigravity-cli');
  const projects = join(home, '.gemini/config/projects');
  return `(version 1)
(allow default)
(deny file-read* file-write* (subpath ${q(home)}))
(allow file-read-metadata (literal ${[home, join(home, '.local'), join(home, '.local/bin'), join(home, '.gemini'), join(home, '.gemini/config'), join(home, 'Library')].map(p => q(p)).join(' ')}))
(allow file-read* (literal ${q(binary)} ${q(join(home, '.gemini/config/config.json'))}))
(allow file-read* (subpath ${q(join(home, 'Library/Keychains'))}))
(allow file-read* file-write* (subpath ${q(cli)}) (subpath ${q(projects)}))
(deny file-read* file-write* (require-all (subpath ${q(cli)}) (regex #"/antigravity-cli/(skills|plugins|mcp|plugin_data|knowledge|implicit|commands|hooks|agents|rules|workflows)(/|\\.|$)")))
(deny file-read* file-write* (require-all (subpath ${q(projects)}) (regex #"/(\\.agents|skills|rules|hooks|plugins|knowledge)(/|\\.|$)")))
(deny file-write* ${workspaces.map(p => `(subpath ${q(p)})`).join(' ')})\n`;
}

async function setup(client, scratch, outputDir) {
  const root = await mkdtemp(join(scratch, `${client}-`));
  const without = await mkdtemp(join(root, 'workspace-'));
  const withSkill = await mkdtemp(join(root, 'workspace-'));
  for (const path of [without, withSkill]) await exec('git', ['init', '--quiet', '--template=', path]);
  await cp(source, join(withSkill, '.agents/skills', name), { recursive: true });
  const { stdout } = await exec('/usr/bin/which', [client]);
  const binary = await realpath(stdout.trim());
  const model = models[client];
  const options = client === 'codex'
    ? await isolatedCodexOptions(without, root, binary, homedir(), process.env.CODEX_HOME)
    : { agyBin: binary, sandboxProfile: join(root, 'agy.sb'), model };
  if (client === 'agy') {
    await writeFile(options.sandboxProfile, agySeatbelt(binary, [without, withSkill]), { mode: 0o600 });
  }
  const catalog = client === 'codex' ? codexCatalog : agyCatalog;
  const providers = {};
  const inventory = {};
  const builtins = {};
  for (const [arm, workspace] of Object.entries({ without, with: withSkill })) {
    const skills = await catalog(workspace, options);
    const local = skills.filter(s => !s.builtin);
    const expected = join(workspace, manifest);
    if (arm === 'with' ? local.length !== 1 || local[0].name !== name || local[0].path !== expected : local.length !== 0) {
      throw new Error(`${client}/${arm}: unexpected local skill catalog`);
    }
    builtins[arm] = skills.filter(s => s.builtin).map(s => s.name).sort();
    inventory[arm] = { builtins: builtins[arm], local: local.map(s => ({ name: s.name, path: manifest })) };
    providers[arm] = client === 'codex' ? codexProvider(workspace, model, options) : agyProvider(workspace, model, options);
  }
  if (JSON.stringify(builtins.with) !== JSON.stringify(builtins.without)) throw new Error(`${client}: built-in catalogs differ`);
  const version = await exec(binary, ['--version']);
  await writeFile(join(outputDir, `${client}-setup.json`), JSON.stringify({ model, version: version.stdout.trim(), inventory, workspaces: { with: withSkill, without } }, null, 2));
  console.log(`${client}: catalogs verified`);
  return { providers, workspaces: { with: withSkill, without } };
}

function observations(client, response) {
  const meta = response.metadata;
  if (client === 'agy') return meta.tools.map(t => ({ tool: t.name, arguments: t.parameters, error: t.failed, result: t.output }));
  return meta.codexAppServer.items.filter(t => !['agentMessage', 'userMessage', 'reasoning'].includes(t.type)).map(t => ({
    tool: t.type, command: t.command, cwd: t.cwd, status: t.status, exit: t.exitCode, result: t.aggregatedOutput?.slice(0, 450),
  }));
}

async function evaluateTrial(promptfoo, setup, client, test, arm, rep) {
  const expected = arm === 'with' && test.shouldActivate;
  const workspace = setup.workspaces[arm];
  const suite = await promptfoo.evaluate({
    prompts: [prompt], providers: [setup.providers[arm]], writeLatestResults: false, sharing: false,
    tests: [{ vars: { request: test.prompt }, assert: [{ type: expected ? 'skill-used' : 'not-skill-used', value: name }] }],
  }, { cache: false, maxConcurrency: 1, showProgressBar: false });
  const [result] = suite.results;
  const response = result?.response;
  const row = { client, arm, rep, case: test.id, expected, latencyMs: result?.latencyMs };
  if (response?.error || !response?.output?.trim()) {
    row.error = String(response?.error ?? result?.error ?? 'Empty provider response').slice(0, 700);
    return row;
  }
  const calls = response.metadata?.skillCalls ?? [];
  row.calls = calls.map(c => ({ name: c.name, path: c.path?.replace(workspace + '/', ''), tool: c.tool, source: c.source }));
  row.promptfooPassed = result.success;
  row.answer = response.output;
  row.actions = observations(client, response);
  const audit = auditReads(client, row.actions, workspace);
  row.reads = audit.reads;
  row.observed = row.reads.length > 0;
  const reported = calls.some(c => c.name === name && !c.is_error);
  row.integrityError = audit.error ?? (reported !== row.observed ? 'Promptfoo and file-read evidence disagree' : undefined);
  row.routingPassed = !row.integrityError && result.success && row.observed === expected;
  row.model = response.metadata?.codexAppServer?.model ?? response.metadata?.model;
  row.tokens = response.tokenUsage;
  return row;
}

async function runClient(client, scratch, outputDir, promptfoo) {
  const fixtures = await setup(client, scratch, outputDir);
  const calibration = await evaluateTrial(promptfoo, fixtures, client, {
    id: 'calibration', shouldActivate: true,
    prompt: 'Usa la herramienta de lectura para abrir el SKILL.md del skill madrid-avisos disponible en este espacio. Devuelve el valor del campo name.',
  }, 'with', 0);
  await writeFile(join(outputDir, `${client}-calibration.json`), JSON.stringify(calibration), { mode: 0o600 });
  if (!calibration.routingPassed) throw new Error(`${client}: positive-control read failed (recorded)`);
  for (const rep of [1, 2]) {
    const ordered = rep === 1 ? cases : cases.toReversed();
    for (const [index, test] of ordered.entries()) {
      const arms = (index + rep) % 2 ? ['with', 'without'] : ['without', 'with'];
      for (const arm of arms) {
        const row = await evaluateTrial(promptfoo, fixtures, client, test, arm, rep);
        await appendFile(join(outputDir, `${client}.ndjson`), JSON.stringify(row) + '\n', { mode: 0o600 });
        console.log(`${client} ${rep} ${test.id} ${arm}: ${row.error ? 'PROVIDER ERROR ' + row.error : row.observed ? 'read' : 'no read'}`);
        if (row.error || row.integrityError) throw new Error(`${client}: ${row.error ? 'provider error' : row.integrityError} (recorded).`);
        if (!row.routingPassed) process.exitCode = 1;
      }
    }
  }
}

const clients = process.argv.slice(2);
if (clients.length === 0) clients.push('codex', 'agy');
if (clients.some(c => !Object.hasOwn(models, c)) || new Set(clients).size !== clients.length) throw new Error('Expected codex and/or agy');
if (process.platform !== 'darwin') throw new Error('This pilot uses the macOS native clients and Seatbelt');
const scratch = await mkdtemp(join(await realpath(tmpdir()), 'arnesto-madrid-'));
const outputDir = join(here, '..', '.promptfoo', 'madrid-avisos', basename(scratch));
await mkdir(outputDir, { recursive: true, mode: 0o700 });
await chmod(outputDir, 0o700);
process.env.PROMPTFOO_CONFIG_DIR = join(scratch, 'promptfoo');
process.env.PROMPTFOO_DISABLE_TELEMETRY = '1';
const promptfoo = await import('promptfoo');
await writeFile(join(outputDir, 'manifest.json'), JSON.stringify({
  date: new Date().toISOString(), skill: name, skillSha256: await skillDigest(source),
  casesSha256: createHash('sha256').update(await readFile(join(here, 'cases.json'))).digest('hex'),
  git: (await exec('git', ['-C', repo, 'rev-parse', 'HEAD'])).stdout.trim(), prompt, repeats: 2, clients,
}, null, 2));
console.log(`Pilot evidence: ${outputDir}`);
// Each evaluate() cleans up the process-wide provider registry when it finishes.
for (const client of clients) {
  try {
    await runClient(client, scratch, outputDir, promptfoo);
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  }
}
if (!process.exitCode) await rm(scratch, { recursive: true, force: true });

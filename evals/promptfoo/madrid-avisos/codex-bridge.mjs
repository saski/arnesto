import { spawn } from 'node:child_process';
import { dirname } from 'node:path';
import { createInterface } from 'node:readline';
import { fileURLToPath } from 'node:url';

const profile = 'arnesto-fixture';

function isPromptfooDefault(policy) {
  return policy?.type === 'readOnly' && policy.networkAccess === false
    && policy.access?.type === 'fullAccess'
    && Object.keys(policy).length === 3 && Object.keys(policy.access).length === 1;
}

export function fixtureConfigArgs(cwd, binary) {
  const reads = [':minimal', cwd, dirname(binary)]
    .map(path => `${JSON.stringify(path)}="read"`).join(', ');
  return [
    '-c', `default_permissions=${JSON.stringify(profile)}`,
    '-c', `permissions.${profile}.filesystem={${reads}}`,
    '-c', `permissions.${profile}.network.enabled=false`,
  ];
}

function launch(binary, exclusionConfig, args) {
  const cwd = process.env.ARNESTO_PILOT_WORKSPACE;
  if (!cwd || args[0] !== 'app-server') throw new Error('Codex bridge requires an arm workspace and app-server');

  const server = spawn(binary, [...args, '-c', exclusionConfig, ...fixtureConfigArgs(cwd, binary)], {
    cwd, stdio: ['pipe', 'pipe', 'inherit'],
  });
  const input = createInterface({ input: process.stdin });
  const output = createInterface({ input: server.stdout });
  const pending = new Set();
  const threads = new Set();
  const fail = reason => {
    console.error(`Codex fixture bridge: ${reason}`);
    process.exitCode = 1;
    input.close();
    output.close();
    server.kill();
  };

  input.on('line', line => {
    const { method, params, id } = JSON.parse(line);
    if (method === 'thread/start') {
      if (params.cwd !== cwd) return fail('thread workspace differs from fixture');
      const { sandbox, ...thread } = params;
      pending.add(id);
      line = JSON.stringify({ method, id, params: { ...thread, permissions: profile } });
    }
    if (method === 'turn/start') {
      const { sandboxPolicy, ...turn } = params;
      if (!threads.has(turn.threadId) || turn.cwd !== cwd || 'permissions' in turn
          || 'permissionProfile' in turn || (sandboxPolicy !== undefined && !isPromptfooDefault(sandboxPolicy))) {
        const message = 'Turn does not inherit a verified fixture profile';
        return process.stdout.write(`${JSON.stringify({ id, error: { code: -32602, message } })}\n`,
          () => fail(message));
      }
      line = JSON.stringify({ method, id, params: turn });
    }
    server.stdin.write(`${line}\n`);
  });

  output.on('line', line => {
    const message = JSON.parse(line);
    if (pending.delete(message.id) && !message.error) {
      const result = message.result;
      if (result?.cwd !== cwd || result.activePermissionProfile?.id !== profile
          || result.sandbox?.type !== 'readOnly' || result.sandbox.networkAccess !== false
          || typeof result.thread?.id !== 'string') {
        return fail('native app-server did not confirm the fixture profile');
      }
      threads.add(result.thread.id);
    }
    process.stdout.write(`${line}\n`);
  });

  input.on('close', () => server.stdin.end());
  server.stdin.on('error', () => fail('native input closed'));
  server.on('error', () => fail('native app-server failed to start'));
  server.on('close', code => {
    input.close();
    process.exitCode ??= code ?? 1;
  });
  process.on('SIGTERM', () => server.kill());
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const [, , binary, exclusionConfig, ...args] = process.argv;
  launch(binary, exclusionConfig, args);
}

import { execFile } from 'node:child_process';
import { realpath } from 'node:fs/promises';
import { homedir } from 'node:os';
import { basename, resolve } from 'node:path';
import { promisify } from 'node:util';

const execFileAsync = promisify(execFile);
const skillName = 'madrid-avisos';
const settings = JSON.stringify({
  agentMode: '',
  toolPermission: 'request-review',
  permissions: {
    deny: [`read_file(${homedir()})`, 'command(*)', 'write_file(*)', 'read_url(*)', 'execute_url(*)', 'download_url(*)', 'mcp(*)'],
  },
});

async function invoke(workspace, { agyBin, sandboxProfile, model }, format, prompt) {
  if (!agyBin || !sandboxProfile || !model) {
    throw new Error('Agy requires an executable, sandbox profile, and pinned model');
  }
  const execution = execFileAsync('/usr/bin/sandbox-exec', [
    '-f', sandboxProfile, agyBin, '--settings', settings, '--model', model,
    '--output-format', format, '--print-timeout', '90s', '--print', prompt,
  ], { cwd: workspace, timeout: 100_000, maxBuffer: 4 * 1024 * 1024 });
  execution.child.stdin.end();
  return execution;
}

function checkResult(result) {
  if (result?.status !== 'SUCCESS') {
    const detail = resultDiagnostic(result);
    throw new Error(detail || 'Agy returned no final status');
  }
}

function redactDiagnostic(value) {
  return value
    .replace(/\x1b\[[0-?]*[ -/]*[@-~]/g, '')
    .replace(/\b(?:https?|wss?|file):\/\/[^\s"'<>]+/gi, '[url]')
    .replace(/\bBearer\s+\S+/gi, 'Bearer [redacted]')
    .replace(/(\b(?:api[-_ ]?key|access[-_ ]?token|refresh[-_ ]?token|authorization|cookie|password|secret)["']?\s*[:=]\s*)(?:"[^"]*"|'[^']*'|[^\s,;}\]]+)/gi, '$1[redacted]')
    .replace(/\b(?:AIza[\w-]{20,}|ya29\.[\w.-]+|sk-[\w-]{16,}|eyJ[\w-]+\.[\w-]+\.[\w-]+)\b/g, '[redacted]')
    .replace(/(["'])\/[^"'\r\n]+\1|(?:^|(?<=[\s(=]))\/[^\s,;:()[\]{}"'<>]+|~\/[^\s,;:()[\]{}"'<>]+/g, '[path]')
    .replace(/[\r\n\t]+/g, ' ')
    .replace(/[\x00-\x1f\x7f]/g, '')
    .trim()
    .slice(0, 350);
}

function diagnosticText(value) {
  if (typeof value === 'string') return value.trim();
  return [value?.message, value?.reason, value?.code, value?.type]
    .filter(part => typeof part === 'string' && part.trim()).join(' ');
}

function resultDiagnostic(result) {
  if (!result || result.status === 'SUCCESS') return '';
  const reason = diagnosticText(result.error) || diagnosticText(result.reason)
    || diagnosticText(result.message) || diagnosticText(result.response);
  return redactDiagnostic([result.status, reason].filter(Boolean).join(': '));
}

function processDiagnostic(error) {
  const structured = error.stdout?.split('\n').reverse() ?? [];
  for (const line of structured) {
    let event;
    try {
      event = JSON.parse(line);
    } catch {
      continue;
    }
    if (event?.event === 'result' || event?.status === 'ERROR') {
      const detail = resultDiagnostic(event.result ?? event);
      if (detail && detail !== 'ERROR') return detail;
    }
    if (String(event?.event ?? event?.type).toLowerCase() === 'error') {
      const detail = redactDiagnostic(diagnosticText(event.error) || diagnosticText(event));
      if (detail) return detail;
    }
  }
  const stderr = error.stderr?.split('\n').reverse().map(redactDiagnostic)
    .find(line => line && !/^(?:at\s|traceback\b|goroutine \d|exit status \d+$)/i.test(line));
  if (stderr) return stderr;
  if (error.name === 'SyntaxError') return 'Invalid JSON from Agy';
  return redactDiagnostic(String(error.signal ?? error.code ?? error.message));
}

function preview(value, maximum) {
  const serialized = typeof value === 'string' ? value : JSON.stringify(value);
  return serialized?.slice(0, maximum);
}

function normalizeTool(step, workspace, inputWorkspace) {
  const info = step.tool_info;
  const name = info?.name ?? step.tool_name;
  const parameters = info?.parameters;
  const failed = Boolean(info?.error || step.error || info?.success === false);
  const reportedSkill = parameters?.skill_name ?? parameters?.skillName
    ?? parameters?.SkillName ?? parameters?.skill ?? parameters?.name ?? parameters?.Name;
  const reportedPath = parameters?.AbsolutePath ?? parameters?.absolute_path
    ?? parameters?.FilePath ?? parameters?.file_path ?? parameters?.Path ?? parameters?.path;
  const exactSkillPath = typeof reportedPath === 'string'
    && [workspace, inputWorkspace].some(root =>
      resolve(root, reportedPath) === resolve(root, '.agents/skills', skillName, 'SKILL.md'));
  const activation = ['activate_skill', 'load_skill', 'use_skill'].includes(name)
    && reportedSkill === skillName;
  const read = ['view_file', 'read_file'].includes(name) && exactSkillPath;
  const hasResult = info?.success === true || (info?.output != null && info.output !== '');
  return {
    stepIndex: step.step_index,
    name,
    failed,
    parameters: preview(parameters, 900),
    output: preview(info?.output, 450),
    error: preview(info?.error ?? step.error, 300),
    skillCall: !failed && hasResult && (activation || read)
      ? { name: skillName, tool: name, stepIndex: step.step_index }
      : undefined,
  };
}

function summarizeStream(stdout, workspace, inputWorkspace) {
  const events = stdout.trim().split('\n').map(line => JSON.parse(line));
  const first = events[0];
  const final = events.at(-1);
  if (first?.event !== 'init' || final?.event !== 'result'
      || events.filter(event => event.event === 'result').length !== 1
      || ![workspace, inputWorkspace].includes(first.init?.cwd)) {
    throw new Error('Invalid Agy event stream for the fixture');
  }
  checkResult(final.result);
  const output = final.result.response?.trim();
  if (!output) throw new Error('Agy returned an empty response');

  const steps = new Map();
  for (const event of events) {
    const step = event.step_update;
    if (event.event === 'step_update' && step?.state === 'DONE'
        && step.step_type === 'tool' && Number.isInteger(step.step_index)) {
      steps.set(step.step_index, normalizeTool(step, workspace, inputWorkspace));
    }
  }
  const tools = [...steps.values()].sort((a, b) => a.stepIndex - b.stepIndex);
  return {
    output,
    metadata: {
      model: first.init.model,
      session: final.result.conversation_id,
      availableTools: first.init.tools?.slice(0, 150),
      skillCalls: tools.flatMap(tool => tool.skillCall ? [tool.skillCall] : []),
      tools: tools.slice(0, 80),
      toolCount: tools.length,
    },
  };
}

export function agyProvider(workspace, model, options) {
  const inputWorkspace = resolve(workspace);
  return {
    id: () => `arnesto:agy:${model}:${basename(inputWorkspace)}`,
    async callApi(prompt) {
      try {
        const cwd = await realpath(inputWorkspace);
        const { stdout } = await invoke(cwd, { ...options, model }, 'stream-json', prompt);
        return summarizeStream(stdout, cwd, inputWorkspace);
      } catch (error) {
        return { error: `Agy evaluation failed: ${processDiagnostic(error)}` };
      }
    },
  };
}

export async function agyCatalog(workspace, options) {
  const cwd = await realpath(workspace);
  const { stdout } = await invoke(cwd, options, 'json', '/skills');
  const parsed = JSON.parse(stdout);
  const result = parsed.result ?? parsed;
  checkResult(result);
  const skills = result.command?.data?.skills;
  if (!Array.isArray(skills)) throw new Error('Agy /skills returned no structured catalog');
  return skills.map(({ name, path, builtin }) => {
    if (typeof name !== 'string' || typeof path !== 'string' || typeof builtin !== 'boolean') {
      throw new Error('Invalid Agy /skills metadata');
    }
    return { name, path, builtin };
  });
}

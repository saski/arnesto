import { execFile } from 'node:child_process';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { promisify } from 'node:util';

const execFileAsync = promisify(execFile);
const repo = fileURLToPath(new URL('../../', import.meta.url));

export default class CodexProvider {
  constructor(options) {
    this.model = options.config.model;
  }

  id() { return `arnesto:codex:${this.model}`; }

  async callApi(prompt) {
    const dir = await mkdtemp(join(tmpdir(), 'arnesto-promptfoo-'));
    const outputPath = join(dir, 'response.txt');
    try {
      const execution = execFileAsync('codex', [
        'exec', '--ephemeral', '--skip-git-repo-check',
        '--model', this.model,
        '--sandbox', 'read-only', '--cd', repo,
        '--output-last-message', outputPath, prompt,
      ], { timeout: 180_000, maxBuffer: 4 * 1024 * 1024 });
      execution.child.stdin.end();
      await execution;
      const output = (await readFile(outputPath, 'utf8')).trim();
      return output ? { output } : { error: 'Codex returned an empty response' };
    } catch (error) {
      const detail = error.stderr?.split('\n').filter(line => line.startsWith('ERROR:')).join('\n');
      return { error: `Codex evaluation failed: ${detail || error.code || error.message}` };
    } finally {
      await rm(dir, { recursive: true, force: true });
    }
  }
}

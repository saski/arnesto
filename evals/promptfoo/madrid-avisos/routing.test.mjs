import assert from 'node:assert/strict';
import test from 'node:test';
import { auditReads } from './routing.mjs';

const root = '/private/tmp/fixture';
const manifest = '.agents/skills/madrid-avisos/SKILL.md';
const header = '---\nname: madrid-avisos\ndescription: Prepare a municipal report';
const command = (path, result, exit = 0) => ({
  tool: 'commandExecution', command: `/bin/zsh -lc 'cat ${path}'`, status: 'completed', exit, result,
});

test('a successful personal copy read invalidates the control even when Promptfoo missed it', () => {
  const action = command('/home/user/.codex/skills/skills/madrid-avisos/SKILL.md', header);
  assert.match(auditReads('codex', [action], root).error, /outside/);
});

test('a file mention or failed command does not establish that Codex read the manifest', () => {
  const listing = { ...command(manifest, manifest), command: `ls ${manifest}` };
  assert.deepEqual(auditReads('codex', [listing, command(manifest, 'Permission denied', 1)], root), { reads: [] });
  assert.equal(auditReads('codex', [command(manifest, header)], root).reads.length, 1);
});

test('Promptfoo redacts the working directory even for a confirmed fixture thread', () => {
  const read = { ...command(manifest, header), cwd: '[REDACTED]' };
  assert.deepEqual(auditReads('codex', [read], root), { reads: [{ tool: 'commandExecution', path: manifest }] });
});

test('Agy must return content or a positive byte count for the fixture read', () => {
  const action = { tool: 'read_file', arguments: JSON.stringify({ Path: `${root}/${manifest}` }), error: false };
  for (const result of ['Permission denied', '0 lines, 0 bytes']) {
    assert.deepEqual(auditReads('agy', [{ ...action, result }], root), { reads: [] });
  }
  assert.equal(auditReads('agy', [{ ...action, result: '112 lines, 6791 bytes' }], root).reads.length, 1);
});

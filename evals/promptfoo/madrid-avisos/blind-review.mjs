import { createHash, randomInt } from 'node:crypto';
import { mkdtemp, readFile, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { auditReads } from './routing.mjs';

const files = process.argv.slice(2);
if (files.length !== 2) throw new Error('Supply the Codex and Agy .ndjson result files');
const caseText = await readFile(new URL('./cases.json', import.meta.url));
const cases = new Map(JSON.parse(caseText).map(test => [test.id, test]));
const casesHash = createHash('sha256').update(caseText).digest('hex');
const candidates = [];
const identities = new Set();
const snapshots = new Set();
for (const file of files) {
  const rows = (await readFile(file, 'utf8')).trim().split('\n').map(line => JSON.parse(line));
  const { client } = rows[0];
  const setup = JSON.parse(await readFile(join(dirname(file), `${client}-setup.json`)));
  const snapshot = JSON.parse(await readFile(join(dirname(file), 'manifest.json')));
  if (snapshot.casesSha256 !== casesHash || !['agy', 'codex'].includes(client)) throw new Error('Unexpected case revision or client');
  snapshots.add(JSON.stringify([snapshot.skillSha256, snapshot.prompt]));
  for (const row of rows) {
    const { arm, rep } = row;
    const test = cases.get(row.case);
    if (!test || row.client !== client || !['with', 'without'].includes(arm) || ![1, 2].includes(rep)
        || row.error || row.integrityError || !row.answer?.trim()) throw new Error('Invalid result row');
    const verified = auditReads(client, row.actions, setup.workspaces[arm]);
    if (verified.error || row.observed !== (verified.reads.length > 0)) throw new Error('Result failed trace audit');
    const identity = { client, arm, rep, case: test.id };
    const unique = JSON.stringify(identity);
    if (identities.has(unique)) throw new Error('Duplicate result row');
    identities.add(unique);
    candidates.push({ identity, answer: { case: test.id, request: test.prompt, criteria: test.criteria, answer: row.answer } });
  }
}
if (candidates.length !== cases.size * 8 || snapshots.size !== 1) throw new Error('Incomplete or mismatched comparison');
for (let i = candidates.length - 1; i > 0; --i) {
  const j = randomInt(i + 1);
  [candidates[i], candidates[j]] = [candidates[j], candidates[i]];
}
const output = await mkdtemp(join(dirname(files[0]), 'review-'));
const blinded = [];
const key = {};
for (const [index, candidate] of candidates.entries()) {
  const id = `R${String(index + 1).padStart(2, '0')}`;
  blinded.push({ id, ...candidate.answer });
  key[id] = candidate.identity;
}
for (const [file, value] of [['blinded.json', blinded], ['review-key.json', key]]) {
  await writeFile(join(output, file), JSON.stringify(value, null, 2) + '\n', { mode: 0o600 });
}
console.log(output);

import { resolve } from 'node:path';

export const manifest = '.agents/skills/madrid-avisos/SKILL.md';
const manifestText = /^name:\s*madrid-avisos\s*$/m;
const manifestPaths = /[^\s'"|;&<>]*madrid-avisos\/SKILL\.md\b/g;

// Codex's built-in skill-used heuristic can miss reads from a personal skill tree.
// Verify the returned manifest as well as the command path before trusting the control.
export function auditReads(client, actions, workspace) {
  const reads = [];
  for (const action of actions) {
    let paths;
    if (client === 'codex') {
      if (action.tool !== 'commandExecution' || action.status !== 'completed' || action.exit !== 0
          || !manifestText.test(action.result ?? '')) continue;
      paths = action.command.match(manifestPaths) ?? [];
    } else {
      if (!['read_file', 'view_file'].includes(action.tool) || action.error) continue;
      const returnedFile = manifestText.test(action.result ?? '')
        || /\b[1-9]\d* lines?, [1-9]\d* bytes?\b/i.test(action.result ?? '');
      if (!returnedFile) continue;
      const params = JSON.parse(action.arguments);
      const path = params.Path ?? params.path ?? params.AbsolutePath ?? params.absolute_path ?? params.FilePath ?? params.file_path;
      if (typeof path !== 'string' || !path.endsWith('madrid-avisos/SKILL.md')) continue;
      paths = [path];
    }
    const cwd = action.cwd === '[REDACTED]' ? workspace : action.cwd ?? workspace;
    if (!paths.length || paths.some(path => resolve(cwd, path) !== resolve(workspace, manifest))) {
      return { reads, error: 'Target manifest read outside the fixture or from an unattributed path' };
    }
    reads.push({ tool: action.tool, path: manifest });
  }
  return { reads };
}

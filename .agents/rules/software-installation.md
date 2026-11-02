<!-- last_updated: 2026-11-02 -->
<!-- version: 1.0 -->
# Software Installation Storage

Required for every agent/client before installing or updating software, downloading installers or dependencies, or building software on any operating system.

## Storage rule

- Always keep software installations, installers, downloaded packages, dependency binaries, virtual environments, package caches, and build artifacts outside folders synchronized with Google Drive or another cloud service.
- Check both the configured destination and its resolved path against the machine's actual sync roots, including backed-up folders. Do not assume that Documents, Desktop, a repository, a home directory, or an OS default is unsynchronized. Verify uncertain destinations before writing installation material.
- Check where the command creates intermediate and final files, including project-local defaults such as `node_modules`, `.venv`, and build/cache directories. A Git ignore rule does not exclude files from Drive synchronization; a symlink inside a synced folder is not proof of exclusion either.

## Choosing a destination

- Prefer existing unsynchronized system or user installation locations. For temporary downloads and staging, use the OS temporary directory, such as `/private/tmp` on macOS or `%TEMP%` on Windows, after checking it is outside sync roots.
- For persistent artifacts and caches, use verified unsynchronized application-data/cache directories: for example, `$XDG_DATA_HOME` / `$XDG_CACHE_HOME` (or their standard fallbacks) on Linux, `~/Library/Application Support` / `~/Library/Caches` on macOS, or `%LOCALAPPDATA%` on Windows.
- If the source project is synchronized, configure tool-supported external dependency/cache/build paths or use an unsynchronized checkout/worktree. Keep source changes and deliverables distinct from generated installation material; do not copy dependencies back into the synced project.
- After installation/build, check that no generated installation material was left under the task's synced roots. Report the installation and artifact locations.

This rule does not authorize deleting or moving existing installations, source code, patches, recovery data, mail backups, or personal documents, or changing cloud-sync settings. Preserve them unless the task explicitly authorizes those changes.

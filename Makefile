.PHONY: check test lint-shell validate-skills validate-cursor-skills validate-openspec validate-symlinks check-tracked-ignored install-hooks install-hermes-gateway-config-watch configure-omniroute-free-coding hermes-update-check hermes-update-stage hermes-update-activate sync-saski-repos sync-saski-repos-apply discover-saski-repos ci-check eval-truthfulness

export PATH := $(HOME)/.agents/bin:$(HOME)/.bun/bin:/opt/homebrew/bin:/usr/local/bin:$(PATH)

SHELL_SCRIPTS := \
	setup-symlinks.sh \
	sync-saski-repos.sh \
	sync-skill-factory.sh \
	pull-and-sync-skills.sh \
	backup-cursor-config.sh \
	hermes-gateway-config-watch.sh \
	install-hermes-gateway-config-watch.sh \
	hermes-update-safe.sh \
	bin/configure-omniroute-free-coding \
	bin/codex-free \
	validate-skill-library.sh \
	validate-cursor-skills.sh \
	lib/validate-skill-frontmatter.sh \
	.agents/skills/openspec/scripts/install-openspec \
	.agents/skills/free-agent-execution/scripts/run-free-worker \
	.agents/skills/free-agent-execution/scripts/validate-routing-manifest \
	.agents/skills/free-agent-execution/scripts/check-omniroute-catalog \
	tests/free-agent-execution-test.sh \
	tests/opencode-free-template-test.sh \
	tests/opencode-managed-config-test.sh \
	tests/setup-symlinks-portability-test.sh \
	tests/codex-config-invariants-test.sh \
	tests/check-omniroute-catalog-test.sh \
	tests/openspec-install-test.sh \
	tests/validate-skill-library-test.sh \
	tests/external-skill-references-test.sh \
	tests/healthcheck-automation-test.sh \
	tests/rtk-global-contract-test.sh \
	tests/cursor-skills-validation-test.sh \
	tests/sync-saski-repos-test.sh \
	tests/sync-skill-factory-test.sh \
	tests/codex-free-entry-test.sh \
	tests/codex-free-switch-test.sh \
	tests/omniroute-free-coding-config-test.sh \
	tests/source-command-bug-fixing-agent-test.sh \
	tests/hermes-routing-template-test.sh \
	tests/universal-agent-rules-test.sh \
	tests/truthfulness-eval-contract-test.sh \
	tests/hermes-gateway-config-watch-test.sh \
	tests/hermes-update-safe-test.sh \
	hooks/pre-commit

check: test lint-shell validate-skills validate-cursor-skills validate-openspec validate-symlinks check-tracked-ignored

test:
	./tests/free-agent-execution-test.sh
	./tests/opencode-free-template-test.sh
	./tests/opencode-managed-config-test.sh
	./tests/setup-symlinks-portability-test.sh
	./tests/codex-config-invariants-test.sh
	./tests/check-omniroute-catalog-test.sh
	./tests/openspec-install-test.sh
	./tests/validate-skill-library-test.sh
	./tests/external-skill-references-test.sh
	./tests/healthcheck-automation-test.sh
	./tests/rtk-global-contract-test.sh
	./tests/cursor-skills-validation-test.sh
	./tests/sync-saski-repos-test.sh
	./tests/sync-skill-factory-test.sh
	./tests/codex-free-entry-test.sh
	./tests/codex-free-switch-test.sh
	./tests/omniroute-free-coding-config-test.sh
	./tests/source-command-bug-fixing-agent-test.sh
	./tests/hermes-routing-template-test.sh
	./tests/universal-agent-rules-test.sh
	./tests/truthfulness-eval-contract-test.sh
	./tests/hermes-gateway-config-watch-test.sh
	./tests/hermes-update-safe-test.sh

lint-shell:
	bash -n $(SHELL_SCRIPTS)
	node --check lib/install-opencode-free-worker-config.mjs

validate-skills:
	./validate-skill-library.sh

validate-cursor-skills:
	./validate-cursor-skills.sh

validate-openspec:
	@command -v openspec >/dev/null 2>&1 || { printf '%s\n' "openspec CLI is required; install OpenSpec before running make check"; exit 1; }
	OPENSPEC_TELEMETRY=0 openspec validate --all

validate-symlinks:
	REPO_DIR="$$(pwd)" ./setup-symlinks.sh validate

check-tracked-ignored:
	@tracked_ignored="$$(git ls-files -ci --exclude-standard)"; \
	if [ -n "$$tracked_ignored" ]; then \
		printf '%s\n' "tracked files ignored by .gitignore (report-only):"; \
		printf '%s\n' "$$tracked_ignored"; \
	else \
		printf '%s\n' "no tracked files are ignored by .gitignore"; \
	fi

install-hooks:
	install -d "$$(dirname "$$(git rev-parse --git-path hooks/pre-commit)")"
	install -m 0755 hooks/pre-commit "$$(git rev-parse --git-path hooks/pre-commit)"

install-hermes-gateway-config-watch:
	./install-hermes-gateway-config-watch.sh

configure-omniroute-free-coding:
	./bin/configure-omniroute-free-coding

hermes-update-check:
	./hermes-update-safe.sh check

hermes-update-stage:
	./hermes-update-safe.sh stage

hermes-update-activate:
	./hermes-update-safe.sh activate

sync-saski-repos:
	./sync-saski-repos.sh

sync-saski-repos-apply:
	./sync-saski-repos.sh --apply

discover-saski-repos:
	./sync-saski-repos.sh --discover

# CI-portable subset of `check`. Excludes checks that depend on the local
# environment: validate-symlinks (HOME tool links), validate-openspec (openspec
# CLI install), validate-skills (sibling-repo skill symlinks), and the
# external-skill-references test (sibling repos). Runs on a stock runner with
# ruby, jq, python3, and git preinstalled.
ci-check: lint-shell validate-cursor-skills
	./tests/free-agent-execution-test.sh
	./tests/opencode-free-template-test.sh
	./tests/opencode-managed-config-test.sh
	./tests/setup-symlinks-portability-test.sh
	./tests/codex-config-invariants-test.sh
	./tests/check-omniroute-catalog-test.sh
	./tests/openspec-install-test.sh
	./tests/validate-skill-library-test.sh
	./tests/healthcheck-automation-test.sh
	./tests/rtk-global-contract-test.sh
	./tests/cursor-skills-validation-test.sh
	./tests/sync-saski-repos-test.sh
	./tests/sync-skill-factory-test.sh
	./tests/codex-free-switch-test.sh
	./tests/omniroute-free-coding-config-test.sh
	./tests/source-command-bug-fixing-agent-test.sh
	./tests/hermes-routing-template-test.sh
	./tests/universal-agent-rules-test.sh
	./tests/truthfulness-eval-contract-test.sh
	./tests/hermes-gateway-config-watch-test.sh
	./tests/hermes-update-safe-test.sh

eval-truthfulness:
	./bin/run-truthfulness-eval "$(TARGET)"

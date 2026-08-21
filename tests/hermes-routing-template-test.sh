#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$REPO_DIR/templates/hermes/dynamic-routing.overlay.yaml"

ruby -ryaml - "$TEMPLATE" <<'RUBY'
path = ARGV.fetch(0)
text = File.read(path)
config = YAML.safe_load(text, aliases: false)

def assert(condition, message)
  abort("FAIL: #{message}") unless condition
end

assert(config.dig("model", "default") == "oc/deepseek-v4-flash-free",
       "free model is the Hermes default")
assert(config.dig("model", "provider") == "omniroute",
       "OmniRoute is the default provider")
assert(config.dig("model", "openai_runtime") == "codex_app_server",
       "Codex OAuth uses the app-server runtime")
assert(config.dig("providers", "omniroute-local", "key_env") == "OMNIROUTE_API_KEY",
       "OmniRoute uses an environment-secret reference")
assert(config.dig("providers", "omniroute-local", "models",
                  "oc/deepseek-v4-flash-free", "supports_vision") == false,
       "the free model is explicitly text-only")
assert(config.dig("providers", "omniroute-local", "models",
                  "combo/free-coding", "supports_vision") == false,
       "the managed free-coding route is selectable and text-only")
assert(config.dig("auxiliary", "vision", "provider") == "openai-codex",
       "images route to OpenAI Codex")
assert(config.dig("auxiliary", "vision", "model") == "gpt-5.6-sol",
       "images route to the frontier Sol model")
assert(config.dig("auxiliary", "vision", "reasoning_effort") == "low",
       "vision preprocessing uses low reasoning effort")
assert(config.dig("agent", "image_input_mode") == "auto",
       "image routing is automatic")

routes = config.dig("gateway", "profile_routes")
assert(routes.is_a?(Array) && routes.length == 1,
       "exactly one Telegram profile route is declared")
assert(routes.first["profile"] == "default",
       "Telegram routes to the default profile")
assert(routes.first["chat_id"] == "REPLACE_WITH_TELEGRAM_CHAT_ID",
       "the committed route contains no local chat identifier")

telegram_tools = config.dig("platform_toolsets", "telegram")
assert(telegram_tools.is_a?(Array), "Telegram toolsets are declared")
assert(!telegram_tools.include?("vision"),
       "the explicit vision tool is absent to prevent duplicate frontier calls")

assert(!text.match?(/\b\d{6,12}:[A-Za-z0-9_-]{20,}\b/),
       "the template contains no Telegram bot token")
assert(!text.match?(/\bsk-[A-Za-z0-9_-]{16,}\b/),
       "the template contains no API key")
assert(!text.match?(/\+34[\s-]*\d/),
       "the template contains no phone number")
assert(!text.include?("free-stack") && !text.include?("free-deterministic"),
       "retired combo names are absent")

puts "PASS: Hermes dynamic routing template"
RUBY

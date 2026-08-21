#!/usr/bin/env bash

set -euo pipefail

node <<'NODE'
const fs = require('fs')
const templatePath = 'templates/opencode/free-worker.jsonc'
const text = fs.readFileSync(templatePath, 'utf8')
const config = JSON.parse(text)
const fail = (message) => {
  console.error(`FAIL: ${message}`)
  process.exit(1)
}
const assert = (condition, message) => {
  if (!condition) fail(message)
}

const provider = config.provider?.omniroute
const worker = config.agent?.['free-worker']
assert(provider?.npm === '@ai-sdk/openai-compatible', 'OmniRoute provider package')
assert(provider?.options?.baseURL === 'http://127.0.0.1:20128/v1', 'OmniRoute base URL')
assert(JSON.stringify(Object.keys(provider?.models ?? {}).sort()) === JSON.stringify([
  'combo/free-coding',
  'oc/big-pickle',
  'oc/deepseek-v4-flash-free',
]), 'exact managed free model set')
assert(worker?.mode === 'primary', 'free-worker mode')
assert(worker?.maxSteps === 3, 'free-worker step cap')
for (const tool of ['read', 'edit']) assert(worker?.tools?.[tool] === true, `${tool} enabled`)
for (const tool of ['bash', 'glob', 'grep', 'question', 'skill', 'task', 'todowrite', 'webfetch']) {
  assert(worker?.tools?.[tool] === false, `${tool} disabled`)
}
assert(worker?.permission?.edit === 'allow', 'edit permission')
for (const permission of ['bash', 'task', 'webfetch', 'external_directory', 'doom_loop']) {
  assert(worker?.permission?.[permission] === 'deny', `${permission} permission`)
}
for (const forbidden of ['auto/', 'gpt', 'openai-codex', 'opencode-zen']) {
  assert(!text.includes(forbidden), `forbidden route ${forbidden}`)
}
console.log('PASS: OpenCode free-worker template')
NODE

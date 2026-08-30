#!/bin/zsh

#------------------------------------------------------------------------------
# zt-agent-routing.zsh
# Тип: Live Agent Smoke Test
# Назначение: проверить выбор семи development skills агентом Marta без выполнения операций
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

if [[ "${ZK_RUN_LIVE_ROUTING:-}" != 1 ]]; then
  print -r -- 'SKIP: set ZK_RUN_LIVE_ROUTING=1 to run the live Marta routing smoke test'
  exit 0
fi

command -v openclaw >/dev/null || { print -u2 -- 'FAIL: openclaw CLI is required'; exit 1; }
command -v jq >/dev/null || { print -u2 -- 'FAIL: jq is required'; exit 1; }

prompt='Routing smoke test only. Do not call tools and do not modify anything. Return exactly one compact JSON object mapping keys development, openspec, script_review, system_review, validation, migration, release to the exact Marta skill name you would select for: implement a scoped CLI fix; design a requirements change; review Zsh scripts; audit architecture/maturity; run repository checks; migrate stored documents/layout; prepare and publish a version. No markdown and no explanation.'
output="$(openclaw agent --agent marta --session-key agent:marta:zt-routing-smoke --thinking minimal --timeout 180 --json --message "$prompt")"

expected='{
  "development":"zettelkasten-development",
  "openspec":"zettelkasten-openspec-change",
  "script_review":"zettelkasten-script-review",
  "system_review":"zettelkasten-system-review",
  "validation":"zettelkasten-validation",
  "migration":"zettelkasten-migration",
  "release":"zettelkasten-release"
}'

jq -e --argjson expected "$expected" '.status == "ok" and .result.meta.aborted == false and (.result.payloads | length) == 1 and ((.result.payloads[0].text | fromjson) == $expected)' <<< "$output" >/dev/null || {
  print -u2 -- 'FAIL: Marta did not route all seven intents to the expected skills'
  print -u2 -- "$output"
  exit 1
}

print -r -- 'PASS: Marta live routing for all seven development skills'

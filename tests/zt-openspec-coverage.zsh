#!/bin/zsh

#------------------------------------------------------------------------------
# zt-openspec-coverage.zsh
# Тип: Development Test
# Назначение: доказать обнаружение missing, duplicate и no-Scenario OpenSpec regressions
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"
checker="$repo/.scripts/dev/zt-openspec-check.zsh"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-openspec-test.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM

reset_fixture() {
  rm -rf -- "$fixture/openspec" "$fixture/host.adoc" "$fixture/plugin.adoc"
  cp -R "$repo/openspec/specs" "$fixture/openspec"
  cp "$repo/.scripts/docs/requirements.adoc" "$fixture/host.adoc"
  cp "$repo/.scripts/zettelkasten/docs/requirements.adoc" "$fixture/plugin.adoc"
}

expect_failure() {
  local expected="$1" output rc
  set +e
  output="$(ZK_OPENSPEC_DIR="$fixture/openspec" ZK_HOST_REQUIREMENTS="$fixture/host.adoc" ZK_PLUGIN_REQUIREMENTS="$fixture/plugin.adoc" "$checker" 2>&1)"
  rc=$?
  set -e
  [[ "$rc" == 10 ]] || { print -u2 -- "FAIL: expected exit 10, got $rc"; print -u2 -- "$output"; return 1; }
  [[ "$output" == *"$expected"* ]] || { print -u2 -- "FAIL: missing diagnostic: $expected"; print -u2 -- "$output"; return 1; }
}

reset_fixture
ZK_OPENSPEC_DIR="$fixture/openspec" ZK_HOST_REQUIREMENTS="$fixture/host.adoc" ZK_PLUGIN_REQUIREMENTS="$fixture/plugin.adoc" "$checker" >/dev/null

reset_fixture
sed -i.bak '/^### Requirement: UUID-001 —/,/^#### Scenario: UUID-001 contract is verified/ { /^### Requirement: UUID-001 —/d; }' "$fixture/openspec/uuid/spec.md"
rm -f "$fixture/openspec/uuid/spec.md.bak"
expect_failure 'legacy requirement must occur exactly once in OpenSpec: UUID-001'

reset_fixture
cat "$fixture/openspec/uuid/spec.md" >> "$fixture/openspec/document-model/spec.md"
expect_failure 'duplicate OpenSpec requirement ID: UUID-001'

reset_fixture
python3 - "$fixture/openspec/uuid/spec.md" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()
start=s.index('#### Scenario: UUID-001 contract is verified')
end=s.index('### Requirement: UUID-002', start)
p.write_text(s[:start]+s[end:])
PY
expect_failure 'requirement has no Scenario'

print -r -- 'PASS: OpenSpec coverage checker negative fixtures'

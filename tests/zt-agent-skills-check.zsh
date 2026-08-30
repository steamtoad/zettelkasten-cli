#!/bin/zsh

#------------------------------------------------------------------------------
# zt-agent-skills-check.zsh
# Тип: Development Test
# Назначение: доказать обнаружение routing, authorization и reference drift skills Marta
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"
checker="$repo/.scripts/dev/zt-agent-skills-check.zsh"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-agent-skills-test.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM

reset_fixture() {
  rm -rf -- "$fixture/skills"
  cp -R "$repo/skills" "$fixture/skills"
}

expect_failure() {
  local expected="$1" output rc
  set +e
  output="$(ZK_DEV_SKILLS_DIR="$fixture/skills" "$checker" 2>&1)"
  rc=$?
  set -e
  [[ "$rc" == 10 ]] || { print -u2 -- "FAIL: expected exit 10, got $rc"; print -u2 -- "$output"; return 1; }
  [[ "$output" == *"$expected"* ]] || { print -u2 -- "FAIL: missing diagnostic: $expected"; print -u2 -- "$output"; return 1; }
}

reset_fixture
ZK_DEV_SKILLS_DIR="$fixture/skills" "$checker" >/dev/null

reset_fixture
sed -i.bak 's/^description:.*/description: "Generic development helper."/' "$fixture/skills/zettelkasten-development/SKILL.md"
rm -f "$fixture/skills/zettelkasten-development/SKILL.md.bak"
expect_failure 'description routing contract drift'

reset_fixture
sed -i.bak 's/Authorization: L0\./Authorization: L1./' "$fixture/skills/zettelkasten-script-review/SKILL.md"
rm -f "$fixture/skills/zettelkasten-script-review/SKILL.md.bak"
expect_failure 'authorization scope drift'

reset_fixture
print -r -- '\nreference drift' >> "$fixture/skills/zettelkasten-validation/references/zettelkasten-development-contract-v1.md"
expect_failure 'common contract hash drift'

print -r -- 'PASS: Marta development skill checker negative fixtures'

#!/bin/zsh

#------------------------------------------------------------------------------
# zt-publish-development-artifacts.zsh
# Тип: Integration Test
# Назначение: проверить публикацию OpenSpec, development skills, tests и sanitized agent artifacts
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"
publisher="$repo/.scripts/zt-develop-publish-version.zsh"
destination="$(mktemp -d "${TMPDIR:-/tmp}/zt-publish-test.XXXXXX")"
trap 'rm -rf -- "$destination"' EXIT HUP INT TERM

command -v rsync >/dev/null || { print -u2 -- 'FAIL: rsync is required'; exit 1; }

mkdir -p "$destination/skills"
print -r -- 'stale' > "$destination/skills/stale.txt"

ZK_DEV_HOME="$repo" ZK_PUBLISH_HOME="$destination" "$publisher" --apply >/dev/null

for d in .scripts openspec skills tests; do
  [[ -d "$destination/$d" ]] || { print -u2 -- "FAIL: published directory missing: $d"; exit 1; }
done

for f in LICENSE README.MD AGENTS.MD .gitignore; do
  [[ -f "$destination/$f" ]] || { print -u2 -- "FAIL: published root artifact missing: $f"; exit 1; }
done

[[ ! -e "$destination/skills/stale.txt" ]] || { print -u2 -- 'FAIL: skills mirror did not delete stale file'; exit 1; }

for private_file in IDENTITY.md SOUL.md USER.md TOOLS.md HEARTBEAT.md; do
  [[ ! -e "$destination/$private_file" ]] || { print -u2 -- "FAIL: private agent artifact was published: $private_file"; exit 1; }
done

cmp -s "$repo/openspec/config.yaml" "$destination/openspec/config.yaml" || { print -u2 -- 'FAIL: OpenSpec config differs after publish'; exit 1; }
cmp -s "$repo/skills/zettelkasten-development/SKILL.md" "$destination/skills/zettelkasten-development/SKILL.md" || { print -u2 -- 'FAIL: development skill differs after publish'; exit 1; }

print -r -- 'PASS: development artifacts publication boundary'

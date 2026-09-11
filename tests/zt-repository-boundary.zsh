#!/bin/zsh

#------------------------------------------------------------------------------
# zt-repository-boundary.zsh
# Тип: Development Test
# Назначение: проверить public/private boundary development-agent artifacts
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"
cd "$repo"

for public_path in AGENTS.MD openspec dev/skills tests dev/scripts scripts/docs/marta-agent.md; do
  [[ -e "$public_path" ]] || { print -u2 -- "FAIL: public development artifact missing: $public_path"; exit 1; }
  if git check-ignore -q -- "$public_path"; then
    print -u2 -- "FAIL: public development artifact is ignored: $public_path"
    exit 1
  fi
done

for private_path in IDENTITY.md SOUL.md USER.md TOOLS.md HEARTBEAT.md; do
  [[ -e "$private_path" ]] || { print -u2 -- "FAIL: local agent artifact missing from prepared workspace: $private_path"; exit 1; }
  git check-ignore -q -- "$private_path" || { print -u2 -- "FAIL: private agent artifact is not ignored: $private_path"; exit 1; }
done

for forbidden in .DS_Store __MACOSX; do
  if git ls-files | grep -Eq "(^|/)${forbidden}(/|$)"; then
    print -u2 -- "FAIL: forbidden distribution artifact is tracked: $forbidden"
    exit 1
  fi
done

print -r -- 'PASS: development repository boundary'

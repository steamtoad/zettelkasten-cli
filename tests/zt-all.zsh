#!/bin/zsh

#------------------------------------------------------------------------------
# zt-all.zsh
# Тип: Development Test Runner
# Назначение: запустить статические regression checks системы разработки Zettelkasten-CLI
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"

"$repo/.scripts/dev/zt-openspec-check.zsh"
"$repo/.scripts/dev/zt-agent-skills-check.zsh"
"$repo/tests/zt-openspec-coverage.zsh"
"$repo/tests/zt-agent-skills-check.zsh"
"$repo/tests/zt-repository-boundary.zsh"
"$repo/tests/zt-publish-development-artifacts.zsh"
"$repo/tests/zt-runtime-core.zsh"
"$repo/tests/zt-agent-routing.zsh"

print -r -- 'PASS: Zettelkasten-CLI development checks'

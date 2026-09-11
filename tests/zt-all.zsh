#!/bin/zsh

#------------------------------------------------------------------------------
# zt-all.zsh
# Тип: Development Test Runner
# Назначение: запустить статические regression checks системы разработки Zettelkasten-CLI
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"

"$repo/dev/scripts/zt-openspec-check.zsh"
"$repo/dev/scripts/zt-agent-skills-check.zsh"
"$repo/tests/zt-openspec-coverage.zsh"
"$repo/tests/zt-openspec-archive-contract.zsh"
"$repo/tests/zt-agent-skills-check.zsh"
"$repo/tests/zt-repository-boundary.zsh"
"$repo/tests/zt-publish-development-artifacts.zsh"
"$repo/tests/zt-runtime-core.zsh"
"$repo/tests/zt-strengthen-document-integrity-checks.zsh"
"$repo/tests/zt-unify-asciidoc-metadata-and-links.zsh"
"$repo/tests/zt-fix-atomic-document-writes.zsh"
"$repo/tests/zt-fix-atomic-write-regressions.zsh"
"$repo/tests/zt-fix-script-ending-idempotency.zsh"
"$repo/dev/scripts/zt-plugin-boundaries-check.zsh"
"$repo/tests/zt-plugin-boundaries.zsh"
"$repo/tests/zt-diary-as-plugin.zsh"
"$repo/tests/zt-validate-diary-and-memo-chains.zsh"
"$repo/tests/zt-inbox-as-plugin.zsh"
"$repo/tests/zt-workspace-as-plugin.zsh"
"$repo/tests/zt-plugin-edge-cases.zsh"
"$repo/tests/zt-agent-routing.zsh"

print -r -- 'PASS: Zettelkasten-CLI development checks'

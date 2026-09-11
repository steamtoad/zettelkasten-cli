# Verification: standardize-cli-preflight-and-selection

Дата: 2026-09-11. Все runtime fixtures используют disposable temporary `ZK_HOME`; реальный Vault, migration, archive, commit, tag и push не выполнялись.

## Baseline и negative evidence

- До implementation сверены `FZF-001`, `FZF-002`, `FZF-003`, `FZF-006`, `LIB-005`, `LIB-006`, `STYLE-007`, `INBOX-008`, `INBOX-011` и audit scenarios G04, G05, G07, G11. Scope ограничен preflight, selection/revalidation, root precedence, processed retry и уточнением поиска.
- `preflight-inbox-editor-before-capture` подтверждён как завершённая зависимость: 9/9 tasks, strict validation PASS. Его изменение `INBOX-008` не пересекается с delta requirements этого Change и уже представлено в baseline.
- Новый `tests/zt-standardize-cli-preflight-and-selection.zsh`, запущенный против чистого исходного `HEAD`, дал ожидаемый FAIL: `missing fzf was reported as success`. Это воспроизводит прежнее маскирование ошибки под cancel.

## Runtime evidence

- `tests/zt-standardize-cli-preflight-and-selection.zsh` — PASS: missing `fzf`, invalid Inbox `EDITOR`, mutation preflight, cancel/no-side-effects, operational selector error, `TARGET_NOT_FOUND`, `STATE_CONFLICT`, root с пробелами/Unicode, приоритет `ZK_HOME`, title с ` - `, same-inode processed retry, different-inode collision и body-only find/read.
- `tests/zt-diary-as-plugin.zsh`, `tests/zt-inbox-as-plugin.zsh`, `tests/zt-workspace-as-plugin.zsh`, `tests/zt-validate-diary-and-memo-chains.zsh`, `tests/zt-unify-asciidoc-metadata-and-links.zsh`, `tests/zt-fix-atomic-document-writes.zsh` и `tests/zt-fix-atomic-write-regressions.zsh` — PASS.
- `tests/zt-plugin-edge-cases.zsh` — PASS, 14/14.
- `tests/zt-all.zsh` — PASS, полный development runner. Live Marta routing сообщил предусмотренный opt-in `SKIP`, поскольку `ZK_RUN_LIVE_ROUTING=1` не задан.

## Specification и repository checks

- `openspec validate --all --strict` — PASS, 66 items.
- `dev/scripts/zt-openspec-check.zsh` — PASS: 351 legacy requirements exactly once.
- `dev/scripts/zt-agent-skills-check.zsh` — PASS: 7 skills.
- `dev/scripts/zt-plugin-boundaries-check.zsh` — PASS: 55 local dependencies.
- Совместный preview проверен для завершённой зависимости `preflight-inbox-editor-before-capture`, ADDED `cli-consistency` и MODIFIED `FZF-002`: `INBOX-008` сохраняется из dependency/baseline, `FZF-001`–`FZF-006` не теряются, новые `CLI-PREFLIGHT-001`–`CLI-PREFLIGHT-004` представлены exact-once.
- `zsh -n` для всех изменённых Zsh files — PASS.
- `shellcheck --shell=bash scripts/lib/selection.zsh` — PASS для нейтральной library. Полная semantic ShellCheck-проверка Zsh — `SKIP`: установленный ShellCheck не поддерживает Zsh language semantics.
- `git diff --check` — PASS.

## Portability и archive readiness

- macOS runtime и ACL/fault-injection branches выполнены. Sandbox warnings `nice(5) failed: operation not permitted` ожидаемы в atomic fault fixture и не изменили успешный exit suite.
- Linux-host runtime — `SKIP`: Linux environment в текущей сессии отсутствует. Portable test code содержит отдельные Darwin/GNU `stat` branches; shell implementation не использует byte-position parsing и проверен Zsh runtime suite.
- Unresolved behavior/spec conflicts не обнаружены. Baseline, legacy traceability, Feature List и README синхронизированы только с подтверждённым поведением; `FZF-006` остаётся `ROADMAP`.
- Change готов к отдельному archive workflow; автоматически он не архивирован.

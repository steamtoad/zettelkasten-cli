# Verification: add-recoverable-workflow-transactions

Дата: 2026-09-11. Все runtime scenarios выполнялись только в disposable temporary `ZK_HOME`; реальный Vault, migration, archive, commit, tag и push не выполнялись.

## Baseline и prerequisites

- До implementation сверены `SAFE-001`, `SAFE-002`, `SAFE-004`, `REFINE-008`, `ZP-DIARY-005`, `FLOW-002` и audit scenarios G01, G03, G08.
- Atomic-write foundation и `unify-asciidoc-metadata-and-links` подтверждены existing suites; `validate-diary-and-memo-chains` имеет 11/11 tasks, `standardize-cli-preflight-and-selection` — 12/12 tasks.
- Scope ограничен creation workflows с activity/bindings, Diary, Continue, Reduce, Refine, neutral transaction engine и read-only обнаружением pending transaction в `zt-check`.
- Новый primary suite, запущенный против чистого исходного `HEAD`, дал ожидаемый FAIL: `successful workflow did not persist a committed transaction manifest`.

## Реализация и focused evidence

- `scripts/lib/transaction.zsh` хранит snapshot, immutable manifest, ordered entries, staged Vault и backups под `.state/transactions`; lock находится в `.state/transaction.lock`.
- Перед каждой заменой проверяются source identity/fingerprint или expected absence. Применяются existing atomic replace/exclusive-create primitives; postflight сверяет каждый target со staged content.
- Apply failure запускает reverse rollback. Неполный rollback сохраняет transaction и backups, перечисляет affected files и возвращает `RECOVERY_REQUIRED`; recovery не заменяет чужую identity.
- `zsh scripts/lib/transaction.zsh recover TRANSACTION_DIR` выполняет явное идемпотентное recovery. Следующий writer блокируется как `LOCKED` для живого owner либо `RECOVERY_REQUIRED` для прерванной transaction.
- Editor запускается только после `committed`; его ошибка сохраняет завершённое знание, возвращает исходный editor exit и не публикует success stdout.
- `tests/zt-add-recoverable-workflow-transactions.zsh` — PASS. Проверены invalid reciprocal binding без публикации первой связи, committed Note binding/Continue/Diary с journal, полный rollback с hashes/modes, rollback failure, affected backup, stale external bytes, два Diary writers, SIGKILL, writer/checker detection и повтор recovery.

## Regression evidence

- `tests/zt-all.zsh` — PASS, полный development runner.
- `tests/zt-fix-atomic-document-writes.zsh` и `tests/zt-fix-atomic-write-regressions.zsh` — PASS. Reduce/Refine fault fixtures обновлены: staged producer/consumer failure больше не публикует temporary journal или partial successor в исходный Vault.
- `tests/zt-diary-as-plugin.zsh`, `tests/zt-validate-diary-and-memo-chains.zsh`, `tests/zt-standardize-cli-preflight-and-selection.zsh`, `tests/zt-unify-asciidoc-metadata-and-links.zsh` — PASS.
- `tests/zt-plugin-edge-cases.zsh` — PASS, 14/14.
- `dev/scripts/zt-plugin-boundaries-check.zsh` — PASS, 62 local dependencies.

## Specification и portability checks

- `openspec validate --all --strict` — PASS, 67 items.
- `dev/scripts/zt-openspec-check.zsh` — PASS: 355 legacy requirements exactly once.
- `zsh -n` для всех изменённых Zsh files — PASS.
- `git diff --check` — PASS.
- Paths с пробелами и Unicode проверены primary/runtime fixtures. Используемые `stat`, identity, atomic replace и exclusive-create primitives сохраняют существующие Darwin/Linux branches.
- Full semantic ShellCheck — `SKIP`: установленный ShellCheck возвращает `SC1071`, потому что не поддерживает Zsh.
- Linux-host runtime — `SKIP`: Linux environment в текущей сессии отсутствует.
- Live Marta routing — предусмотренный opt-in `SKIP`, поскольку `ZK_RUN_LIVE_ROUTING=1` не задан.
- macOS sandbox выводит ожидаемые `nice(5) failed: operation not permitted` в concurrent/fault fixtures; suites завершаются PASS и не используют этот warning как доказательство.

## Совместимость и archive readiness

- Совместный preview сохраняет владельцев prerequisite IDs: chain и CLI-preflight requirements не переопределяются; `TXN-001`–`TXN-004` добавлены exact-once. `SAFE-002` остаётся broad `ROADMAP`, поскольку delta не изменяет его stable contract.
- Cooperative lock не объявлен защитой от внешних non-cooperating tools: такие edits обнаруживаются fingerprint/identity revalidation. Power-loss/fsync durability сверх проверенного filesystem contract не заявляется.
- Unresolved behavior/spec conflicts не обнаружены. Change готов к отдельному archive workflow, но автоматически не архивирован.

## 1. Readiness и ownership

- [x] 1.1 Зафиксировать current baseline, code и verification evidence для `SAFE-001`, `SAFE-002`, `SAFE-004`, `CHECK-004`, `ZP-DIARY-005`, `FLOW-002` и завершённых core safety changes; проверить exact-once legacy traceability и записать конкретный blocker для каждого неподтверждённого prerequisite.
- [x] 1.2 Подтвердить, что `validate-diary-and-memo-chains`, `standardize-cli-preflight-and-selection` и `add-recoverable-workflow-transactions` остаются единственными владельцами `CHAIN-CHECK-*`, `CLI-PREFLIGHT-*`/`FZF-002` и `TXN-*`; проверить targeted search по baseline и active changes на competing IDs.
- [x] 1.3 Реализовать и верифицировать owner changes в порядке из design либо отметить integration tasks `BLOCKED` до их принятия; подтвердить каждый переход через актуальные tasks, focused suite, baseline sync и verification evidence, не повышая status по одному planning artifact. `BLOCKED` recorded in `readiness.md`; owner implementations are outside this change's scope.

## 2. Structured handoff и phase engine

- [ ] 2.1 Определить neutral immutable handoff schema для operation identity, selected objects, document/state fingerprints, expected-absent targets, chain assertions, dependencies, ordered write set и postflight; проверить positive fixture и rejection missing/duplicate/unknown fields для `FLOW-SAFE-002`.
- [ ] 2.2 Реализовать единый phase coordinator `preflight → chain validation → freeze plan → staging → revalidation → apply → postflight` без plugin policy в neutral layer; проверить trace/order scenarios `FLOW-SAFE-001` и boundary checker.
- [ ] 2.3 Подключить owner chain и selector/preflight results к handoff без разбора human stdout; проверить stale selected Memo и stale Diary tail как `STATE_CONFLICT` без изменения временного Vault.
- [ ] 2.4 Реализовать fingerprint/absence revalidation перед первой и каждой релевантной заменой; проверить внешний edit и concurrent Diary writer, включая сохранение чужих bytes и отсутствие второго `next`.
- [ ] 2.5 Разделить primary failure и recovery outcome в итоговом result; проверить apply+rollback double failure, cancel до mutation и unresolved transaction для writer/checker по `FLOW-SAFE-003`.

## 3. Совместная regression verification

- [ ] 3.1 Создать `tests/zt-integrate-chain-preflight-transactions.zsh` с временным `ZK_HOME`, public entrypoints, deterministic fake dependencies/fault hooks и before/after hashes/modes; показать failure на реализации без integration contract.
- [ ] 3.2 Проверить в integration suite успешный Diary/Memo workflow, stale selection, stale chain tail, dependency failure, apply failure, rollback failure, interruption, idempotent recovery/retry и отсутствие out-of-scope mutations; сохранить exit/stdout/stderr и phase evidence для `FLOW-SAFE-001..004`.
- [ ] 3.3 Запустить focused suites трёх owner changes, новый integration suite и полный `tests/zt-all.zsh`; отдельно записать `PASS`, `FAIL`, `BLOCKED`, `NOT-RUN` и optional `SKIP`, не заменяя joint gate component tests.
- [ ] 3.4 Проверить Zsh syntax, macOS/Linux portability затронутых constructs, paths с пробелами/Unicode, plugin dependency direction и public entrypoint compatibility; каждую недоступную optional environment проверку отметить `SKIP` с причиной.

## 4. Traceability и acceptance

- [ ] 4.1 После подтверждённой реализации добавить `FLOW-SAFE-001..004` exact-once в canonical baseline и legacy requirements с доказанным status; обновить Feature List/README только по executable evidence и не менять владельцев dependent IDs.
- [ ] 4.2 Выполнить `openspec validate --all --strict`, `dev/scripts/zt-openspec-check.zsh` и `git diff --check`; проверить совместный preview со всеми тремя owner changes и отсутствие baseline/active-delta conflicts.
- [ ] 4.3 Подготовить `verification.md` с командами, версиями, fixture scope, hashes, результатами всех scenarios и остаточными limitations; подтвердить все tasks и archive readiness, не выполняя автоматически mutation реального Vault, commit, tag, push или archive.

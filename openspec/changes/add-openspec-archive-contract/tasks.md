## 1. Specification governance

- [ ] 1.1 Синхронизировать `OS-ARCHIVE-001..005` в canonical `spec-governance` после implementation approval и проверить unique IDs.
- [ ] 1.2 Добавить stable IDs и PROCESS/INVARIANT statuses в legacy traceability, затем проверить parity.

## 2. Archive enforcement

- [ ] 2.1 Добавить readiness check implementation/tasks/verification/spec validation.
- [ ] 2.2 Добавить canonical delta synchronization и post-sync validation gate.
- [ ] 2.3 Проверять полную сохранность proposal, design, tasks и delta specs в archive.

## 3. Verification

- [ ] 3.1 Добавить primary regression test `tests/zt-openspec-archive-contract.zsh` с positive и negative fixtures.
- [ ] 3.2 Выполнить `openspec validate --all`, `.scripts/dev/zt-openspec-check.zsh`, `tests/zt-all.zsh` и `git diff --check`.

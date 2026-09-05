# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [ ] 1.1 Зафиксировать current baseline для `SAFE-001`, `SAFE-002`, `SAFE-004`, `REFINE-008`, `ZP-DIARY-005`, `FLOW-002` и локальные сценарии G01, G03, G08; подтвердить область и зависимости из design до правки implementation.
- [ ] 1.2 Создать `tests/zt-add-recoverable-workflow-transactions.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [ ] 2.1 Реализовать `TXN-001` согласно полному delta contract; проверить в primary test сценарии «План невалиден», «Успешная операция».
- [ ] 2.2 Реализовать `TXN-002` согласно полному delta contract; проверить в primary test сценарии «Сбой rollback», «Полный rollback».
- [ ] 2.3 Реализовать `TXN-003` согласно полному delta contract; проверить в primary test сценарии «Внешняя правка после плана», «Два Diary writers».
- [ ] 2.4 Реализовать `TXN-004` согласно полному delta contract; проверить в primary test сценарии «SIGKILL во время apply», «Повтор recovery».

## 3. Регрессия и интеграция

- [ ] 3.1 Запустить `tests/zt-add-recoverable-workflow-transactions.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [ ] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [ ] 3.3 После реализации синхронизировать `TXN-001`, `TXN-002`, `TXN-003`, `TXN-004` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [ ] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [ ] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

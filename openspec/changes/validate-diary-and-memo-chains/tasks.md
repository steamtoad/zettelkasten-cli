# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [ ] 1.1 Зафиксировать current baseline для `DATA-003`, `PATH-007`, `ZP-DIARY-004`, `ZP-DIARY-005`, `CHAIN-001`, `CHAIN-006`, `CHECK-005` и локальные сценарии G02, G03; подтвердить область и зависимости из design до правки implementation.
- [ ] 1.2 Создать `tests/zt-validate-diary-and-memo-chains.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [ ] 2.1 Реализовать `CHAIN-CHECK-001` согласно полному delta contract; проверить в primary test сценарии «Pointer указывает на Note», «Первая запись».
- [ ] 2.2 Реализовать `CHAIN-CHECK-002` согласно полному delta contract; проверить в primary test сценарии «Невзаимность и цикл», «Две записи одной даты».
- [ ] 2.3 Реализовать `CHAIN-CHECK-003` согласно полному delta contract; проверить в primary test сценарии «Пример не создаёт ветку», «Ветвление допустимо».
- [ ] 2.4 Реализовать `CHECK-002` согласно полному delta contract; проверить в primary test сценарии «Инициализированный пустой Vault».

## 3. Регрессия и интеграция

- [ ] 3.1 Запустить `tests/zt-validate-diary-and-memo-chains.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [ ] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [ ] 3.3 После реализации синхронизировать `CHAIN-CHECK-001`, `CHAIN-CHECK-002`, `CHAIN-CHECK-003`, `CHECK-002` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [ ] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [ ] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

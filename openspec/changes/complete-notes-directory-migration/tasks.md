# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [x] 1.1 Зафиксировать current baseline для `PATH-001`, `PATH-008`, `PATH-010`, `PATH-011`, `MIGR-002`, `MIGR-003`, `MIGR-005`, `CHECK-004` и локальные сценарии G06; подтвердить область и зависимости из design до правки implementation.
- [x] 1.2 Создать `tests/zt-complete-notes-directory-migration.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [x] 2.1 Реализовать `MIGRATE-LINK-001` согласно полному delta contract; проверить в primary test сценарии «Корневой overview», «Необрабатываемый источник».
- [x] 2.2 Реализовать `MIGRATE-LINK-002` согласно полному delta contract; проверить в primary test сценарии «Смешанный граф», «Коллизия назначения».
- [x] 2.3 Реализовать `MIGRATE-LINK-003` согласно полному delta contract; проверить в primary test сценарии «Сломанная корневая ссылка после apply», «Повтор миграции».

## 3. Регрессия и интеграция

- [x] 3.1 Запустить `tests/zt-complete-notes-directory-migration.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [x] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [x] 3.3 После реализации синхронизировать `MIGRATE-LINK-001`, `MIGRATE-LINK-002`, `MIGRATE-LINK-003` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [x] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [x] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

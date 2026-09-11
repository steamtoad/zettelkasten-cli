# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [x] 1.1 Зафиксировать current baseline для `DOC-002`, `DOC-003`, `DOC-009`, `UUID-001`, `CHECK-002`, `CHECK-011`, `CHECK-017` и локальные сценарии G02, G04; подтвердить область и зависимости из design до правки implementation.
- [x] 1.2 Создать `tests/zt-strengthen-document-integrity-checks.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [x] 2.1 Реализовать `INTEGRITY-001` согласно полному delta contract; проверить в primary test сценарии «Пустой файл», «Схема нарушена».
- [x] 2.2 Реализовать `INTEGRITY-002` согласно полному delta contract; проверить в primary test сценарии «Не UUID v1», «UUID v1 принимается».
- [x] 2.3 Реализовать `INTEGRITY-003` согласно полному delta contract; проверить в primary test сценарии «Header injection через title», «Спецсимволы допустимого текста».
- [x] 2.4 Реализовать `INTEGRITY-004` согласно полному delta contract; проверить в primary test сценарии «Topic без key», «Deprecated не отменяет базовую схему».
- [x] 2.5 Реализовать `CHECK-011` согласно полному delta contract; проверить в primary test сценарии «Новая проверка доступна».

## 3. Регрессия и интеграция

- [x] 3.1 Запустить `tests/zt-strengthen-document-integrity-checks.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [x] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [x] 3.3 После реализации синхронизировать `INTEGRITY-001`, `INTEGRITY-002`, `INTEGRITY-003`, `INTEGRITY-004`, `CHECK-011`, `CHECK-017` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [x] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [x] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

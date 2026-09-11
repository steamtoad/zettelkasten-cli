# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [x] 1.1 Зафиксировать current baseline для `STYLE-003`, `CHECK-006` и локальные сценарии G09; подтвердить область и зависимости из design до правки implementation.
- [x] 1.2 Создать `tests/zt-fix-script-ending-idempotency.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [x] 2.1 Реализовать `CHECK-006` согласно полному delta contract; проверить в primary test сценарии «Корректный файл», «Отсутствует LF».
- [x] 2.2 Реализовать `SCRIPT-FORMAT-001` согласно полному delta contract; проверить в primary test сценарии «Read-only lint», «Write failure».

## 3. Регрессия и интеграция

- [x] 3.1 Запустить `tests/zt-fix-script-ending-idempotency.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [x] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [x] 3.3 После реализации синхронизировать `CHECK-006`, `SCRIPT-FORMAT-001` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [x] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [x] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

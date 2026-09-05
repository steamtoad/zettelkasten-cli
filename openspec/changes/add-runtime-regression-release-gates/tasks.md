# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [ ] 1.1 Зафиксировать current baseline для `CHECK-008`, `CHECK-009`, `CHECK-019`, `CHECK-020`, `CHECK-021`, `CHECK-023`, `SPEC-001`, `STYLE-005` и локальные сценарии G11, G01, G02, G03, G04, G05, G06, G07, G08, G09, G10; подтвердить область и зависимости из design до правки implementation.
- [ ] 1.2 Создать `tests/zt-add-runtime-regression-release-gates.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [ ] 2.1 Реализовать `RUNTIME-GATE-001` согласно полному delta contract; проверить в primary test сценарии «Текст есть, поведения нет», «Доказанный контракт».
- [ ] 2.2 Реализовать `RUNTIME-GATE-002` согласно полному delta contract; проверить в primary test сценарии «Дефект Reduce возвращён», «Все supported workflows».
- [ ] 2.3 Реализовать `RUNTIME-GATE-003` согласно полному delta contract; проверить в primary test сценарии «Linux UUID», «Агент не подключён».
- [ ] 2.4 Реализовать `RUNTIME-GATE-004` согласно полному delta contract; проверить в primary test сценарии «Существуют незавершённые задачи», «Change архивирован».
- [ ] 2.5 Реализовать `RUNTIME-GATE-005` согласно полному delta contract; проверить в primary test сценарии «Выгрузка скриптов», «Неполная проверка».

## 3. Регрессия и интеграция

- [ ] 3.1 Запустить `tests/zt-add-runtime-regression-release-gates.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [ ] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [ ] 3.3 После реализации синхронизировать `RUNTIME-GATE-001`, `RUNTIME-GATE-002`, `RUNTIME-GATE-003`, `RUNTIME-GATE-004`, `RUNTIME-GATE-005` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [ ] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [ ] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [ ] 1.1 Зафиксировать current baseline для `ARCH-005`, `ARCH-006`, `ARCH-008`, `ARCH-009`, `ARCH-010`, `ARCH-011`, `ARCH-012`, `FLOW-002`, `FLOW-003`, `FLOW-004` и локальные сценарии G12; подтвердить область и зависимости из design до правки implementation.
- [ ] 1.2 Создать `tests/zt-add-zcreate-workflow.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [ ] 2.1 Реализовать `ZCREATE-001` согласно полному delta contract; проверить в primary test сценарии «Пять типов», «Старый entrypoint».
- [ ] 2.2 Реализовать `ZCREATE-002` согласно полному delta contract; проверить в primary test сценарии «Pipeline», «Не хватает title».
- [ ] 2.3 Реализовать `ZCREATE-003` согласно полному delta contract; проверить в primary test сценарии «Отказ journal», «Создание без binding».
- [ ] 2.4 Реализовать `ZCREATE-004` согласно полному delta contract; проверить в primary test сценарии «Дата Memo в прошлом», «Несогласованные связи».
- [ ] 2.5 Реализовать `ZCREATE-005` согласно полному delta contract; проверить в primary test сценарии «Шаблон пытается сменить тип», «Контекст выбран явно».
- [ ] 2.6 Реализовать `FLOW-003` согласно полному delta contract; проверить в primary test сценарии «No-edit как явное исключение».

## 3. Регрессия и интеграция

- [ ] 3.1 Запустить `tests/zt-add-zcreate-workflow.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [ ] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [ ] 3.3 После реализации синхронизировать `ZCREATE-001`, `ZCREATE-002`, `ZCREATE-003`, `ZCREATE-004`, `ZCREATE-005`, `FLOW-003` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [ ] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [ ] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

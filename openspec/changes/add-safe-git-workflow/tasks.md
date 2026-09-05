# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [ ] 1.1 Зафиксировать current baseline для `ARCH-001`, `SAFE-001`, `SAFE-004`, `MIGR-005`, `PUB-016` и локальные сценарии G12, G08; подтвердить область и зависимости из design до правки implementation.
- [ ] 1.2 Создать `tests/zt-add-safe-git-workflow.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [ ] 2.1 Реализовать `ZT-GIT-001` согласно полному delta contract; проверить в primary test сценарии «Dirty repository».
- [ ] 2.2 Реализовать `ZT-GIT-002` согласно полному delta contract; проверить в primary test сценарии «Локальная правка», «Чистое отставание».
- [ ] 2.3 Реализовать `ZT-GIT-003` согласно полному delta contract; проверить в primary test сценарии «Конфликт Note».

## 3. Регрессия и интеграция

- [ ] 3.1 Запустить `tests/zt-add-safe-git-workflow.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [ ] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [ ] 3.3 После реализации синхронизировать `ZT-GIT-001`, `ZT-GIT-002`, `ZT-GIT-003` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [ ] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [ ] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

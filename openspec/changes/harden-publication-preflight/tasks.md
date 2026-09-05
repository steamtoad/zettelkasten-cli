# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [ ] 1.1 Зафиксировать current baseline для `PUB-004`, `PUB-007`, `PUB-008`, `PUB-010`, `PUB-016`, `PUB-023`, `PUB-025` и локальные сценарии G08; подтвердить область и зависимости из design до правки implementation.
- [ ] 1.2 Создать `tests/zt-harden-publication-preflight.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [ ] 2.1 Реализовать `PUB-SAFE-001` согласно полному delta contract; проверить в primary test сценарии «Вложенное назначение», «Корректная пара».
- [ ] 2.2 Реализовать `PUB-SAFE-002` согласно полному delta contract; проверить в primary test сценарии «Dirty файл внутри scripts», «Чистый прошлый релиз».
- [ ] 2.3 Реализовать `PUB-SAFE-003` согласно полному delta contract; проверить в primary test сценарии «Source изменился», «План актуален».
- [ ] 2.4 Реализовать `PUB-SAFE-004` согласно полному delta contract; проверить в primary test сценарии «Второй mirror отказал», «Успешная поставка».

## 3. Регрессия и интеграция

- [ ] 3.1 Запустить `tests/zt-harden-publication-preflight.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [ ] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [ ] 3.3 После реализации синхронизировать `PUB-SAFE-001`, `PUB-SAFE-002`, `PUB-SAFE-003`, `PUB-SAFE-004` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [ ] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [ ] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

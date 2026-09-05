# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [ ] 1.1 Зафиксировать current baseline для `SAFE-001`, `SAFE-002`, `STYLE-006`, `UUID-001`, `REDUCE-012`, `LINK-004` и локальные сценарии G01, G04; подтвердить область и зависимости из design до правки implementation.
- [ ] 1.2 Создать `tests/zt-fix-atomic-document-writes.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [ ] 2.1 Реализовать `WRITE-SAFE-001` согласно полному delta contract; проверить в primary test сценарии «Отказ записи подготовленного файла», «Успешная замена».
- [ ] 2.2 Реализовать `WRITE-SAFE-002` согласно полному delta contract; проверить в primary test сценарии «Отказ добавления Note linkage», «Нормальный Reduce».
- [ ] 2.3 Реализовать `WRITE-SAFE-003` согласно полному delta contract; проверить в primary test сценарии «Конкурирующие create», «Symlink на назначении».
- [ ] 2.4 Реализовать `WRITE-SAFE-004` согласно полному delta contract; проверить в primary test сценарии «Отказ обратной Memo-ссылки», «Ошибка чтения».

## 3. Регрессия и интеграция

- [ ] 3.1 Запустить `tests/zt-fix-atomic-document-writes.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [ ] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [ ] 3.3 После реализации синхронизировать `WRITE-SAFE-001`, `WRITE-SAFE-002`, `WRITE-SAFE-003`, `WRITE-SAFE-004` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [ ] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [ ] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

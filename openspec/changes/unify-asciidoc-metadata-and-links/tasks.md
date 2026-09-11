# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [x] 1.1 Зафиксировать current baseline для `DOC-009`, `LINK-001`, `LINK-002`, `CHECK-003`, `CHECK-022`, `LIB-001`, `REFINE-012`, `WORKSPACE-014` и локальные сценарии G04, G05; подтвердить область и зависимости из design до правки implementation.
- [x] 1.2 Создать `tests/zt-unify-asciidoc-metadata-and-links.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [x] 2.1 Реализовать `ADOC-PARSE-001` согласно полному delta contract; проверить в primary test сценарии «Псевдоатрибут после пробельной границы», «Сломанная граница».
- [x] 2.2 Реализовать `ADOC-PARSE-002` согласно полному delta contract; проверить в primary test сценарии «Dedup по примеру», «Повторный запуск».
- [x] 2.3 Реализовать `ADOC-PARSE-003` согласно полному delta contract; проверить в primary test сценарии «Смешанная строка», «Управляемая строка».
- [x] 2.4 Реализовать `ADOC-PARSE-004` согласно полному delta contract; проверить в primary test сценарии «Parity constructors», «Граница зависимостей».

## 3. Регрессия и интеграция

- [x] 3.1 Запустить `tests/zt-unify-asciidoc-metadata-and-links.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [x] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [x] 3.3 После реализации синхронизировать `ADOC-PARSE-001`, `ADOC-PARSE-002`, `ADOC-PARSE-003`, `ADOC-PARSE-004` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [x] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [x] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

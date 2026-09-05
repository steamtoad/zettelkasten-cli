# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [ ] 1.1 Зафиксировать current baseline для `DATA-004`, `TOPIC-001`, `BIND-003`, `REDUCE-003`, `REDUCE-006`, `REDUCE-008`, `DEPR-008`, `REFINE-011` и локальные сценарии G10, G02; подтвердить область и зависимости из design до правки implementation.
- [ ] 1.2 Создать `tests/zt-clarify-topic-membership-contract.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [ ] 2.1 Реализовать `DATA-004` согласно полному delta contract; проверить в primary test сценарии «Memo без прямой ссылки», «Siblings сохраняются».
- [ ] 2.2 Реализовать `TOPIC-MEMBER-001` согласно полному delta contract; проверить в primary test сценарии «Два активных Topic», «Отказ от preview».
- [ ] 2.3 Реализовать `TOPIC-MEMBER-002` согласно полному delta contract; проверить в primary test сценарии «История Reduce», «Новая связь в архив».
- [ ] 2.4 Реализовать `TOPIC-MEMBER-003` согласно полному delta contract; проверить в primary test сценарии «Archive-source в Refine», «Название отличается от ключа».

## 3. Регрессия и интеграция

- [ ] 3.1 Запустить `tests/zt-clarify-topic-membership-contract.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [ ] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [ ] 3.3 После реализации синхронизировать `DATA-004`, `TOPIC-MEMBER-001`, `TOPIC-MEMBER-002`, `TOPIC-MEMBER-003` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [ ] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [ ] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

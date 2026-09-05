# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [ ] 1.1 Зафиксировать current baseline для `PATH-001`, `PATH-008`, `LIB-005`, `CHECK-001`, `ARCH-001` и локальные сценарии G12, G07; подтвердить область и зависимости из design до правки implementation.
- [ ] 1.2 Создать `tests/zt-add-vault-inspection.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [ ] 2.1 Реализовать `VAULT-001` согласно полному delta contract; проверить в primary test сценарии «Explicit root».
- [ ] 2.2 Реализовать `VAULT-002` согласно полному delta contract; проверить в primary test сценарии «Опечатка root».

## 3. Регрессия и интеграция

- [ ] 3.1 Запустить `tests/zt-add-vault-inspection.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [ ] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [ ] 3.3 После реализации синхронизировать `VAULT-001`, `VAULT-002` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [ ] 3.4 Выполнить `openspec validate --all --strict`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [ ] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

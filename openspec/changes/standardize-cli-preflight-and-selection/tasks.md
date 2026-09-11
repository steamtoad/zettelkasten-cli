# Задачи реализации и проверки

Все задачи ниже относятся к будущей реализации; подготовка спецификаций не означает их выполнения.

## 1. Контракт и fixtures

- [x] 1.1 Зафиксировать current baseline для `FZF-001`, `FZF-002`, `FZF-003`, `FZF-006`, `LIB-005`, `LIB-006`, `STYLE-007`, `INBOX-008`, `INBOX-011` и локальные сценарии G04, G05, G07, G11; подтвердить область и зависимости из design до правки implementation.
- [x] 1.2 Создать `tests/zt-standardize-cli-preflight-and-selection.zsh` с временным ZK_HOME, исходными hashes/modes и observable assertions сценариев specs; показать, какие негативные fixtures не проходят на прежней реализации.

## 2. Реализация требований

- [x] 2.1 Реализовать `CLI-PREFLIGHT-001` согласно полному delta contract; проверить в primary test сценарии «Отсутствует fzf», «Невалидный EDITOR Inbox».
- [x] 2.2 Реализовать `CLI-PREFLIGHT-002` согласно полному delta contract; проверить в primary test сценарии «Пользователь отменяет», «Цель удалена после выбора».
- [x] 2.3 Реализовать `CLI-PREFLIGHT-003` согласно полному delta contract; проверить в primary test сценарии «Root с пробелами», «Title содержит разделительный текст».
- [x] 2.4 Реализовать `CLI-PREFLIGHT-004` согласно полному delta contract; проверить в primary test сценарии «Прерывание после ln», «Разные файлы с одним именем».
- [x] 2.5 Реализовать `FZF-002` согласно полному delta contract; проверить в primary test сценарии «Термин только в body».

## 3. Регрессия и интеграция

- [x] 3.1 Запустить `tests/zt-standardize-cli-preflight-and-selection.zsh` и затронутые existing runtime tests; проверить hashes вне scope, exit/stdout/stderr, cancel и отказ обязательных операций.
- [x] 3.2 Проверить применимые macOS/Linux differences, syntax изменённых Zsh и portable suite; явно записать SKIP optional integration, не выдавая его за PASS.
- [x] 3.3 После реализации синхронизировать `CLI-PREFLIGHT-001`, `CLI-PREFLIGHT-002`, `CLI-PREFLIGHT-003`, `CLI-PREFLIGHT-004`, `FZF-002` в canonical specs и legacy exact-once traceability; обновить Feature List/README только по доказанным возможностям.
- [x] 3.4 Выполнить `openspec validate --all --strict`, `dev/scripts/zt-openspec-check.zsh` и `git diff --check` на затронутых файлах; проверить совместный preview с зависимостями и сохранить evidence.
- [x] 3.5 Проверить, что выполнены все tasks и нет unresolved behavior/spec conflicts; подготовить archive readiness, не архивируя автоматически и не выполняя commit/tag/push.

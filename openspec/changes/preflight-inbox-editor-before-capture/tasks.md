## 1. Контракт и regression fixtures

- [x] 1.1 Зафиксировать current behavior `INBOX-008` и затронутые assertions в `tests/lib/plugin_contracts.py`/Inbox suites; подтвердить, что существующий negative fixture оставляет raw после отсутствующего editor.
- [x] 1.2 Добавить regression scenarios через `scripts/zt-inbox.zsh` с временным `ZK_HOME` для unset, явно пустого, отсутствующего и quoted `EDITOR`; проверить exit/stdout/stderr, список файлов и отсутствие Inbox directories/raw на preflight failure.

## 2. Реализация INBOX-008

- [x] 2.1 Изменить `scripts/inbox/capture.zsh`: различать unset и empty `EDITOR`, один раз безопасно разобрать command и проверить executable до `mkdir`, timestamp и raw reservation; проверить focused Inbox test.
- [x] 2.2 Сохранить success behavior для default `vim` и quoted executable/arguments, включая пустой argument и literal shell-like text; проверить существующие `quoted_editor`, Unicode и collision regressions.
- [x] 2.3 Проверить failure paths: пустой editor сообщает `EDITOR must not be empty`, отсутствующий executable называется в stderr, оба возвращают ненулевой exit без stdout success path и без filesystem side effects.

## 3. Спецификация и интеграционная проверка

- [x] 3.1 После подтверждённой реализации синхронизировать полный `INBOX-008` в `openspec/specs/inbox/spec.md`, `scripts/inbox/docs/requirements.adoc` и `scripts/inbox/docs/features.adoc`, сохранив stable ID и exact-once traceability.
- [x] 3.2 Запустить затронутые Inbox/plugin tests, syntax checks изменённых Zsh и применимый portable suite; optional unavailable checks записать как `SKIP`, а не `PASS`.
- [x] 3.3 Выполнить `openspec validate --all --strict`, `dev/scripts/zt-openspec-check.zsh`, `dev/scripts/zt-agent-skills-check.zsh`, `dev/scripts/zt-plugin-boundaries-check.zsh` и `git diff --check`; сохранить verification evidence в change.
- [x] 3.4 Подтвердить отсутствие изменений реального Vault, migration/commit/tag/push и unresolved contract conflicts; подготовить change к archive без автоматического архивирования и отдельно указать необходимость согласовать dependency в `standardize-cli-preflight-and-selection`.

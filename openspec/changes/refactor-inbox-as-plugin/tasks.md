## 1. Зафиксировать совместимость

- [ ] 1.1 Создать `tests/zt-inbox-as-plugin.zsh`, который через top-level entrypoints и временный `ZK_HOME` фиксирует существующие capture/processed contracts `INBOX-001`–`INBOX-012`; проверить, что тест проходит на исходной реализации.
- [ ] 1.2 Добавить в regression test structural assertions для наличия `.scripts/inbox/{capture,processed}.zsh`, тонкого `exec` delegation с сохранением `"$@"` и отсутствия запрещённых cross-layer references; проверить, что assertions различают исходное и целевое устройство.

## 2. Выделить Inbox plugin

- [ ] 2.1 Создать `.scripts/inbox/` и перенести capture workflow в `.scripts/inbox/capture.zsh` без изменения CLI, output, collision и data-path semantics; проверить capture-сценарии в `tests/zt-inbox-as-plugin.zsh`.
- [ ] 2.2 Перенести processed workflow в `.scripts/inbox/processed.zsh` без изменения path safety, same-filesystem hard-link atomicity и error behavior; проверить processed-сценарии в `tests/zt-inbox-as-plugin.zsh`.
- [ ] 2.3 Превратить `.scripts/zt-inbox.zsh` и `.scripts/zt-processed.zsh` в executable `exec` compatibility wrappers с полным forwarding аргументов; проверить stdout/stderr/exit parity и неизменный managed skill mapping.
- [ ] 2.4 Добавить или расширить repository boundary check для `IP-ARCH-001` и `IP-ARCH-002`; проверить, что `.scripts/inbox/` не зависит от `.scripts/zettelkasten/`, а neutral engine, objects и Zettelkasten plugin не зависят от Inbox plugin.

## 3. Синхронизировать документацию и traceability

- [ ] 3.1 Создать `.scripts/inbox/docs/requirements.adoc` как единственный plugin-specific legacy traceability source, перенести соответствующие стабильные IDs без дублирования и проверить правило «каждый active legacy ID представлен ровно один раз».
- [ ] 3.2 Создать `.scripts/inbox/docs/features.adoc` и обновить агрегирующий Feature List, описав отдельный Inbox plugin, публичные wrappers и неизменный `ZK_HOME/inbox/{raw,processed}`; проверить ссылки и отсутствие ложного заявления о реализованном ROADMAP import.
- [ ] 3.3 Обновить development/validation documentation для дальнейшей работы с Inbox внутри текущего `zettelkasten-cli`; проверить, что она не предлагает отдельный repository, data migration или замену managed operational skills.

## 4. Выполнить итоговую проверку

- [ ] 4.1 Выполнить `zsh -n` для изменённых Zsh files и `tests/zt-inbox-as-plugin.zsh`; исправить все syntax failures.
- [ ] 4.2 Запустить `tests/zt-inbox-as-plugin.zsh` во временном `ZK_HOME` и подтвердить capture, collision, editor arguments, path/symlink safety, atomic processed behavior и отсутствие изменений реального Vault.
- [ ] 4.3 Запустить профильные repository checks и `tests/zt-all.zsh`; подтвердить, что новые failures отсутствуют, а unrelated pre-existing failures документированы отдельно.
- [ ] 4.4 Запустить `openspec validate refactor-inbox-as-plugin --strict`, `openspec validate --all`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check`; подтвердить валидность delta, traceability и чистоту patch formatting.

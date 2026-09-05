## 1. Зафиксировать существующий Diary contract

- [ ] 1.1 Создать основной regression test `tests/zt-diary-as-plugin.zsh`, вызывающий `.scripts/zt-diary.zsh` только с временным `ZK_HOME`; проверить на текущей реализации создание Diary, UUID/metadata, `.last-diary`, previous/next links, `all-todays`, Vim argument, output link и exit status.
- [ ] 1.2 Добавить в test сценарии invalid `.last-diary` и ошибок до обновления state; проверить сохранение `ZP-DIARY-004` и `ZP-DIARY-005` без изменений настоящего Vault.
- [ ] 1.3 Добавить structural assertions для direct `exec` delegation в `.scripts/diary/`, отсутствия канонического Diary workflow под `.scripts/zettelkasten/` и запрещённых cross-layer references; проверить, что assertions различают исходную и целевую архитектуру.

## 2. Выделить Diary plugin

- [ ] 2.1 Создать `.scripts/diary/zt-diary.zsh` и перенести канонический workflow без изменения observable side-effect order; проверить behavioral сценарии `tests/zt-diary-as-plugin.zsh`.
- [ ] 2.2 Создать Diary-specific helper для регистрации в `all-todays` под `.scripts/diary/lib/` без зависимости от `.scripts/zettelkasten/`; проверить точное совпадение формата и поведения с `ZP-TODAY-001`–`ZP-TODAY-003`.
- [ ] 2.3 Переключить `.scripts/zt-diary.zsh` на прямой `exec` нового plugin с полным forwarding `"$@"`, затем удалить `.scripts/zettelkasten/zt-diary.zsh`; проверить stdout/stderr/exit parity, executable mode и mapping `zt-diary.zsh` → `zettelkasten-diary`.
- [ ] 2.4 Добавить или расширить repository boundary check для `DP-ARCH-001`, `DP-ARCH-002` и изменённого `ARCH-016`; проверить разрешённые `diary -> objects/lib/diary/lib` и отсутствие зависимостей `diary <-> zettelkasten` и обратных engine dependencies.

## 3. Перенести документацию и traceability

- [ ] 3.1 Создать `.scripts/diary/docs/requirements.adoc`, перенести туда `ZP-DIARY-001`–`ZP-DIARY-005` без смены stable IDs и удалить их дубликаты из Zettelkasten plugin documentation; проверить exact-once legacy coverage.
- [ ] 3.2 Создать `.scripts/diary/docs/features.adoc`, перенести Diary feature ownership из `.scripts/zettelkasten/docs/features.adoc` и обновить агрегирующий `.scripts/docs/features.adoc`; проверить, что Diary остаётся функцией продукта, но не заявляется как workflow Zettelkasten plugin.
- [ ] 3.3 Обновить architecture и development documentation согласно `ARCH-014`, `ARCH-016`, `ARCH-017` и `ZP-ARCH-003`; проверить, что diagram/tree, dependency rules и compatibility paths указывают `.scripts/diary/` и не предлагают отдельный repository или data migration.

## 4. Выполнить итоговую проверку

- [ ] 4.1 Выполнить `zsh -n` для всех изменённых Zsh files и `tests/zt-diary-as-plugin.zsh`; исправить все syntax failures.
- [ ] 4.2 Запустить `tests/zt-diary-as-plugin.zsh` и `tests/zt-runtime-core.zsh` с временными Vault; подтвердить Diary plugin behavior и неизменность neutral Diary constructor/document model.
- [ ] 4.3 Запустить профильные boundary/documentation checks и `tests/zt-all.zsh`; подтвердить отсутствие новых failures и документировать unrelated pre-existing failures отдельно.
- [ ] 4.4 Запустить `openspec validate refactor-diary-as-plugin --strict`, `openspec validate --all`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check`; подтвердить валидность delta, exact-once traceability и patch formatting.

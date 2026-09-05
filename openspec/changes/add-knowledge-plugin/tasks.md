## 1. Зафиксировать target contract тестами

- [ ] 1.1 Создать `tests/zt-knowledge-plugin.zsh` с временным `ZK_HOME`, fixtures активных Note/Memo и structural assertions для `.scripts/knowledge/` и thin `exec` wrappers.
- [ ] 1.2 Добавить failing scenarios для create: safe human-readable filename/title, configured editor path, cancel, collision, traversal, separator, symlink и non-regular target rejection.
- [ ] 1.3 Добавить failing scenarios для link/check: Note/Memo↔Knowledge relative paths, target type/activity validation, idempotency, mode preservation, broken/one-sided/escaping relations и failure-injection rollback.

## 2. Создать отдельный Knowledge plugin

- [ ] 2.1 Создать `.scripts/knowledge/` и plugin-specific documentation; реализовать общий path/boundary layer, который разрешает `ZK_HOME/knowledge` и отклоняет traversal/symlink escape.
- [ ] 2.2 Реализовать canonical create workflow с безопасным человекочитаемым `.adoc` basename, AsciiDoc title, collision protection, cancel semantics и editor invocation без core metadata.
- [ ] 2.3 Реализовать canonical link workflow: выбор regular Knowledge reference и активной Note/Memo, повторная defensive validation, физически относительные links, plugin-managed sections и идемпотентность по target path.
- [ ] 2.4 Реализовать staged update/rollback обеих сторон с сохранением file mode и очисткой temporary artifacts; проверить failure injection до и после первой замены.
- [ ] 2.5 Реализовать Knowledge checker для storage boundary, regular files, target existence/type/activity, relative path safety и взаимности managed relations.
- [ ] 2.6 Добавить executable `.scripts/zt-knowledge-{create,link,check}.zsh` как thin `exec` wrappers с полным forwarding `"$@"` и parity exit/stdout/stderr.

## 3. Интегрировать plugin без изменения core model

- [ ] 3.1 Расширить repository boundary check: разрешить `.scripts/knowledge/` → `.scripts/lib/`, запретить его dependency на `.scripts/objects/`/`.scripts/zettelkasten/`/sibling plugins и любые обратные dependencies.
- [ ] 3.2 Подключить `zt-knowledge-check.zsh` к подходящей aggregate validation на host-уровне без source/import dependency core Zettelkasten plugin на Knowledge.
- [ ] 3.3 Добавить plugin-specific legacy requirements с новыми стабильными `KNOW-*` IDs и обновить OpenSpec traceability coverage без удаления, дублирования или изменения status существующих IDs.
- [ ] 3.4 Обновить `.scripts/docs/features.adoc`, README/architecture documentation и command inventory, явно отличив Knowledge reference от core Note и не заявляя nested layout или lifecycle integration.

## 4. Проверить изменение

- [ ] 4.1 Выполнить `zsh -n` для всех новых/изменённых Zsh scripts и tests; проверить executable bits, canonical headers, quoting и LF endings.
- [ ] 4.2 Запустить `tests/zt-knowledge-plugin.zsh` и профильные boundary/validation tests; подтвердить все create/link/check и rollback scenarios на временном Vault.
- [ ] 4.3 Запустить `tests/zt-all.zsh`; новые failures исправить, unrelated pre-existing failures перечислить отдельно.
- [ ] 4.4 Запустить `openspec validate add-knowledge-plugin --strict`, `openspec validate --all`, `.scripts/dev/zt-openspec-check.zsh` и `git diff --check`; подтвердить delta validity, baseline traceability и patch formatting.


## 1. Inventory и preflight

- [x] 1.1 Зафиксировать Git worktree status, inventory tracked/untracked файлов и все ссылки на `.scripts/`, `skills/`, `scripts/` и `dev/skills/`; проверить, что целевые `scripts/` и `dev/skills/` не существуют и что пользовательские каталоги не входят в scope.
- [x] 1.2 Добавить или обновить migration/preflight check, который требует `AGENTS.MD`, `openspec/config.yaml`, `.scripts/docs/requirements.adoc` до rename и защищает `notes/`, `all-todays/`, `workspaces/`, `inbox/`, `.last-diary`, `.state/`; проверить failure на коллизии и небезопасный worktree.

## 2. Перенос repository layout

- [x] 2.1 Переименовать `.scripts/` в `scripts/` с сохранением содержимого, executable permissions и внутренней структуры; проверить отсутствие старого каталога и наличие `scripts/zt-*.zsh`, `scripts/lib/`, `scripts/objects/`, plugins и `scripts/dev/`.
- [x] 2.2 Перенести `skills/` в `dev/skills/`, сохранив все development skill names, references и LF/permissions; проверить, что каждый ожидаемый `dev/skills/zettelkasten-*` существует и root `skills/` удалён.
- [x] 2.3 Обновить shell source paths, repository resolver, host entrypoints, dev tooling, tests, README/AGENTS и OpenSpec context/traceability на canonical `scripts/` и `dev/skills/`; проверить repository-wide search на непреднамеренные старые пути.
- [ ] 2.4 Обновить `scripts/docs/managed-skills.adoc` и связанные script mappings без изменения внешнего runtime state; проверить `scripts/zt-skills-review.zsh` на согласованность manifest и Detailed Notes.

## 3. Compatibility и validation

- [x] 3.1 Обновить plugin boundary, OpenSpec и agent-skills checks на новые корни; проверить `scripts/dev/zt-plugin-boundaries-check.zsh` и `scripts/dev/zt-openspec-check.zsh` в новом layout.
- [x] 3.2 Обновить regression tests и repository-boundary tests; прогнать их на временном `ZK_HOME` и подтвердить, что constructors, `scripts/zt-check.zsh`, link validation и пользовательский Vault contract не изменились.
- [x] 3.3 Проверить compatibility entrypoints и прямые documented invocations всех `scripts/zt-*.zsh`, включая exit status, stdout/stderr и editor behavior, а также зафиксировать policy для старых `scripts/*` и `dev/skills/*` callers.
- [x] 3.4 Выполнить `openspec validate --all` (если CLI доступен), `scripts/dev/zt-openspec-check.zsh`, релевантные tests, `git diff --check -- <changed-files>` и Git diff summary; при сбое выполнить rollback/recovery по design.md и не продолжать migration автоматически.
- [x] 3.5 Провести финальный negative search по старым repository paths и проверить, что изменения не затронули `notes/`, `all-todays/`, `workspaces/`, `inbox/`, `.last-diary`, `.state/` и внешние managed skills.

## MODIFIED Requirements

### Requirement: WORKSPACE-012 — zt-workspace-remove.zsh через один fzf --multi выбирает и одним атомарным переписыванием удал...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Workspace remove SHALL через один fzf --multi выбирать active/deprecated/broken targets ../notes/UUID.adoc и одним atomic rewrite удалять только выбранные link macros за пределами supported code blocks. Не выбранные ссылки и окружающий ручной текст MUST сохраняться; bullet line удаляется целиком только если после удаления macro содержит лишь bullet marker и whitespace.

#### Scenario: WORKSPACE-012 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Mixed links and manual text

- **WHEN** выбрана одна из нескольких ссылок в строке Workspace
- **THEN** удалён только выбранный macro, соседние ссылки и текст сохранены


#### Scenario: Inline workspace link

- **WHEN** выбрана ссылка в обычном тексте вне bullet list
- **THEN** удаляется macro без удаления окружающего текста


### Requirement: WORKSPACE-013 — удаление ссылки из Workspace игнорирует поддерживаемые блоки кода, выполняется через временны...

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Агрегаторы и Workspace`.

Workspace remove MUST игнорировать supported code blocks, создавать temporary file в том же каталоге и filesystem, что и Workspace, сохранять исходный file mode и заменять файл только после успешной подготовки. Ошибка подготовки или замены MUST оставлять исходный Workspace неизменным и удалять созданный temporary file.

#### Scenario: WORKSPACE-013 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Failed rewrite cleanup

- **WHEN** подготовка или final replacement завершается ошибкой
- **THEN** исходные bytes и mode сохранены, temporary file отсутствует


#### Scenario: Same filesystem staging

- **WHEN** TMPDIR расположен на другом filesystem
- **THEN** temporary file всё равно создаётся рядом с Workspace для atomic rename


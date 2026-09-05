## Context

Core Zettelkasten documents имеют UUID v1 identity, обязательную metadata schema и находятся непосредственно в `notes/`. Справочные материалы отличаются по назначению: это внешнее по отношению к системе знание — выдержки, инструкции, словари и другие reference-документы, которые пользователь хочет хранить локально и связывать с рабочими Memo/Note.

Помещение reference-документов в `notes/` размывает `PATH-001`, `DATA-001` и `DATA-002`. Помещение их произвольно в repository root затрудняет выбор, валидацию и переносимость ссылок. Поэтому capability вводит отдельные data boundary `knowledge/` и code boundary `.scripts/knowledge/`, сохраняя их в одном Vault и Git repository.

## Goals / Non-Goals

**Goals:**

- дать справочным AsciiDoc-документам стабильное место рядом с `notes/`;
- позволить пользователю явно создавать reference и связывать его с активной Note/Memo в обе стороны;
- сохранить ссылки переносимыми, относительными и проверяемыми;
- изолировать Knowledge implementation в отдельном sibling plugin;
- не затронуть существующую core document model и реальные пользовательские данные при разработке.

**Non-Goals:**

- вводить новый `:type: knowledge` или UUID identity;
- автоматически импортировать существующие файлы либо классифицировать содержимое;
- включать Knowledge в Topic binding, Memo Chain, Reduce/Refine, `all-todays`, Workspace или общий индекс;
- поддерживать binary assets, remote references, runtime plugin discovery или отдельный repository/package;
- разрешать связь Knowledge с Todo, Diary или Topic в этой дельте.

## Decisions

### 1. Data boundary — `ZK_HOME/knowledge/`, code boundary — `.scripts/knowledge/`

`knowledge/` является sibling-каталогом `notes/` и содержит управляемые plugin обычные `.adoc` reference-документы. `.scripts/knowledge/` содержит canonical create/link/check workflow и plugin-specific documentation. Top-level `.scripts/zt-knowledge-*.zsh` остаются тонкими `exec` entrypoints.

Knowledge plugin может использовать только собственный код и domain-neutral primitives `.scripts/lib/`. Он может читать metadata выбранной Note/Memo как данные, но не source'ит `.scripts/zettelkasten/` и `.scripts/objects/`. Существующие слои не импортируют Knowledge plugin; repository-level entrypoint или aggregate validation может оркестрировать sibling plugins без обратной source dependency.

Альтернатива `.scripts/zettelkasten/knowledge/` отклонена: reference не является системным Zettelkasten document type. Отдельный repository отклонён: материалы должны оставаться рядом с Vault и участвовать в его Git history.

### 2. Knowledge document имеет человекочитаемое имя, но не core metadata

Create workflow принимает непустой title, формирует безопасный человекочитаемый basename с suffix `.adoc`, отклоняет path separators, traversal, collision и symlink escape, создаёт AsciiDoc title и открывает файл настроенным editor. Он не добавляет UUID, `:type:`, `:key-topic:`, `:deprecated:`, `:doclink:` или `:docfilename:` автоматически.

В первой версии plugin управляет только `.adoc` файлами непосредственно в `knowledge/`. Это даёт однозначные ссылки `../knowledge/<name>.adoc` из `notes/` и `../notes/UUID.adoc` из `knowledge/`. Вложенная иерархия остаётся отдельным расширением, потому что требует отдельной политики filename collision, selection и relative-path validation.

### 3. Связывание является явной атомарной операцией

Link workflow предлагает один regular `.adoc` из `knowledge/` и одну активную core Note/Memo из `notes/`. Тип и active status проверяются повторно после выбора. В core документ добавляется relative link `../knowledge/<name>.adoc`; в Knowledge document — `../notes/UUID.adoc`. Description берётся из AsciiDoc title/канонического description target и экранируется существующим neutral helper.

Перед записью plugin строит обе новые версии во временных файлах в соответствующих каталогах, проверяет их и заменяет оба target с сохранением mode. Если подготовка или commit второй стороны не может быть завершён, исходное содержимое обеих сторон восстанавливается. Повторный запуск определяет существующую связь по нормализованному target path и не создаёт duplicate heading/link.

Альтернатива разрешить ручную независимую запись каждой стороны отклонена: она делает обещанную двусторонность необязательной и оставляет silent broken links.

### 4. Проверка принадлежит Knowledge plugin

`zt-knowledge-check.zsh` проверяет regular-file/symlink boundary, допустимые `.adoc` files, относительные links между `knowledge/` и `notes/`, тип и active status обратных targets и взаимность связей, созданных plugin. Он не принимает каждый произвольный URL или AsciiDoc link за plugin-managed relation; managed sections/markers должны позволять отличать Knowledge relation от пользовательского текста.

Существующий `zt-check` не получает source dependency на Knowledge plugin. Aggregate repository check может отдельно вызвать оба публичных checker entrypoint. Это сохраняет направление зависимостей и оставляет core validation работоспособной без установленного Knowledge plugin.

## Risks / Trade-offs

- [Человекочитаемые filenames могут изменяться пользователем] → ссылки проверяются как filesystem-relative targets; rename workflow не входит в эту дельту и ручное переименование диагностируется как broken link.
- [Частичная запись оставит одностороннюю связь] → staged writes, rollback обеих исходных версий и failure-injection integration scenarios.
- [Reference ошибочно станет core document] → отсутствие `:type:`/UUID требований и явное исключение из core selectors/lifecycle.
- [Symlink выведет plugin за Vault boundary] → проверять canonical parent/target paths до чтения и записи; не следовать symlink за `knowledge/` или `notes/`.
- [Новый checker продублирует `zt-check`] → использовать neutral parsing primitives, но оставить orchestration внутри owning plugin.
- [Root-only layout ограничит большие библиотеки] → принять как простую первую версию; nested layout проектировать отдельной дельтой.

## Migration Plan

1. Добавить failing integration/structural test на временном `ZK_HOME` для storage, wrappers, create/link/check и dependency boundary.
2. Создать `.scripts/knowledge/`, canonical workflows и plugin-specific docs; добавить thin public entrypoints.
3. Реализовать безопасное создание root-level reference и атомарное двустороннее связывание только с активными Note/Memo.
4. Реализовать plugin checker и включить его в подходящую aggregate validation без зависимости core plugin на Knowledge.
5. Синхронизировать Feature List и legacy traceability с новыми Knowledge IDs, не меняя статусы существующих IDs.
6. Выполнить integration, boundary, OpenSpec и repository validation на временном Vault.

Автоматического data migration нет. Rollback кода удаляет wrappers/plugin только до появления пользовательских Knowledge files. После использования plugin rollback не должен удалять `knowledge/` или переписывать Note/Memo; recovery состоит в сохранении данных и forward fix. Любая будущая миграция reference-документов из других мест требует отдельного change с dry-run и Git preflight.


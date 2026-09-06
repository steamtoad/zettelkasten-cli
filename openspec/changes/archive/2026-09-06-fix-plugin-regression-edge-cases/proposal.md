## Why

Расширенная проверка выполненных refactor-diary/inbox/workspace-as-plugin выявила дефекты, скрытые прежними regression fixtures: capture падает на Unicode пути и quoted editor, processed принимает symlink на соседний raw и трактует каталог назначения как directory operand, Workspace удаляет несвязанный текст и ссылки из общей строки, а boundary checker пропускает source в command substitution.

## What Changes

- Исправить capture для Unicode пути, quoted editor и коллизий, сохранив O_EXCL и прежний порядок editor preflight.
- Отвергать symlink source и любое существующее назначение processed; использовать точный atomic hard-link destination, включая concurrent directory collision.
- Удалять только выбранные link macros из Workspace, сохраняя остальную строку и supported code blocks; staging выполняется рядом с Workspace с cleanup при ошибке.
- Диагностировать зависимости внутри command substitution и не принимать relative source path за доказанную file-relative dependency.
- Добавить негативные tests и повторно проверить все три выполненные дельты через публичные entrypoints.

## Capabilities

### Modified Capabilities
- `inbox`: INBOX-007, INBOX-008, INBOX-009, INBOX-010.
- `workspace`: WORKSPACE-012, WORKSPACE-013.
- `architecture`: ARCH-016.

## Impact

Изменяются Inbox/Workspace implementations, development boundary checker, tests и traceability documentation. Diary и neutral constructors проходят повторную проверку. UUID/data layout, публичные пути и managed mappings не меняются. Миграция пользовательских данных, import, Git/release и transaction framework не входят в scope. Исправления оформлены отдельным change, а не переопределяют историю механического переноса.

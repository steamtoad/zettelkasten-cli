## Why

Сейчас Zettelkasten-CLI хранит системные UUID-документы в `notes/`, но не имеет отдельного пространства для справочных материалов, которые полезно держать рядом с Vault и связывать с Memo/Note, не включая в lifecycle Topic, Reduce/Refine и `all-todays`. Размещение таких материалов в `notes/` ошибочно придаёт им semantics core document model, а repository-level размещение не даёт единого layout и проверяемых ссылок.

Нужен отдельный Knowledge plugin в текущем репозитории: он владеет sibling-каталогом `knowledge/`, создаёт и связывает обычные AsciiDoc reference-документы, но не расширяет множество системных типов Zettelkasten.

## What Changes

- Вводится пользовательский каталог `ZK_HOME/knowledge/` рядом с `ZK_HOME/notes/` для обычных AsciiDoc reference-документов, не относящихся к core document model.
- Вводится sibling plugin `.scripts/knowledge/` с каноническими workflow создания reference-документа, двустороннего связывания с активной Note/Memo и проверки Knowledge-ссылок.
- Добавляются публичные compatibility entrypoints `.scripts/zt-knowledge-create.zsh`, `.scripts/zt-knowledge-link.zsh` и `.scripts/zt-knowledge-check.zsh`, делегирующие Knowledge plugin.
- Knowledge document получает безопасное человекочитаемое имя `.adoc` и заголовок, но не обязан иметь UUID filename, `:type:`, `:key-topic:`, `:deprecated:` или metadata core document model.
- Связи Note/Memo → Knowledge и Knowledge → Note/Memo создаются как относительные AsciiDoc links, вычисленные от физического расположения source; операция связывания является идемпотентной и не оставляет одностороннюю связь при ошибке.
- Knowledge plugin проверяет отсутствие выхода из `knowledge/`, допустимость target type, активность Note/Memo и разрешимость обеих сторон ссылок.
- Не изменяются semantics существующих Note, Memo, Todo, Diary и Topic; Knowledge не участвует автоматически в Topic binding, Memo Chain, Reduce, Refine, search index, Workspace или `all-todays`.

## Capabilities

### New Capabilities

- `knowledge-plugin`: storage boundary `knowledge/`, отдельная plugin architecture, публичные workflow создания/связывания/проверки и reference-link semantics.

### Modified Capabilities

Нет. Существующие `document-model`, `document-paths`, `links` и `plugin-architecture` сохраняют текущий contract core documents; новая capability задаёт интеграцию, не переопределяя legacy requirements.

## Impact

- Затрагиваемые области: `.scripts/knowledge/`, три новых top-level entrypoint, plugin-specific documentation, агрегирующий Feature List, boundary/validation checks и новый integration test.
- Архитектурный эффект: L4 — новый sibling plugin, который может зависеть только от domain-neutral `.scripts/lib/`; neutral engine, object layer, Zettelkasten plugin и другие sibling plugins не зависят от Knowledge plugin.
- Совместимость: `DOC-003`, `PATH-001`, `PATH-002`, `PATH-008`, `PATH-009`, `DATA-001`, `DATA-002`, `LINK-001`–`LINK-007`, `ZP-ARCH-001`–`ZP-ARCH-005` сохраняются. `knowledge/` не становится частью `notes/` namespace и Knowledge не становится шестым persistent document type.
- Миграция: автоматическая миграция отсутствует. Установка plugin создаёт `knowledge/` только при явном create workflow и не перемещает существующие файлы из `notes/` или repository root.
- Destructive operations: отсутствуют. Link workflow меняет только явно выбранные два документа и должен восстанавливать исходное содержимое обоих при частичной ошибке.
- User data: implementation и integration tests используют временный `ZK_HOME`; реальный Vault не читается и не изменяется обычной development-задачей.
- Legacy traceability: новые Knowledge IDs добавляются при реализации как отдельная plugin-specific traceability group; существующие stable IDs не удаляются, не переиспользуются и не меняют status.


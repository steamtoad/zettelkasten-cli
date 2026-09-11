## Why

`openspec/specs/zettelkasten-cli-agent/spec.md` содержит развитый master-документ, но оформлен как отдельный план: в нём отсутствуют обязательные корневые секции `## Purpose` и `## Requirements`. Поэтому содержательно полезная спецификация не проходит `openspec validate --specs --strict`, а её требования и сценарии не распознаются каноническим парсером OpenSpec.

## What Changes

- Привести существующий master-документ к канонической структуре OpenSpec: добавить `## Purpose` и `## Requirements` в правильных местах.
- Сохранить все существующие требования `ASYS-001`–`ASYS-032`, их normative wording, статусы, таблицы, матрицы, планы и scenarios без смыслового переписывания.
- Проверить, что каждый requirement остаётся под `## Requirements`, имеет `#### Scenario:` и сохраняет исходный текст без потери контекста.
- Удалить или преобразовать только структурные элементы, которые мешают OpenSpec parser; не менять scope, ownership, roadmap claims или фактический статус реализации.
- Добавить regression-проверку `openspec validate --specs --strict` и проверить отсутствие побочных изменений в остальных baseline specs.

## Capabilities

### New Capabilities

Нет. Новая функциональность не добавляется.

### Modified Capabilities

Нет. Изменяется только каноническое оформление существующей master-spec, без изменения normative behavior или requirement semantics. Change использует `skip_specs: true`.

## Impact

- Затрагивается только `openspec/specs/zettelkasten-cli-agent/spec.md` и, при необходимости, связанная документация/validation evidence.
- Это структурная спецификационная правка без изменения CLI, shell implementation, пользовательских данных, UUID, links, runtime skills или deployment.
- Не требуется migration, rollback пользовательских данных или изменение stable requirement IDs.

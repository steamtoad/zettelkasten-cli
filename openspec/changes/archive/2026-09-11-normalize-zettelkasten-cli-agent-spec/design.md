## Context

Фактический baseline-файл находится в `openspec/specs/zettelkasten-cli-agent/spec.md`. Он содержит 32 требования `ASYS-001`–`ASYS-032` и сценарии, но оформлен как расширенный master-документ с нумерованными разделами, а не как каноническая OpenSpec specification. `openspec validate --specs --strict` останавливается на отсутствии обязательных `## Purpose` и `## Requirements`.

## Goals / Non-Goals

**Goals:**

- Сделать master-spec распознаваемым стандартным OpenSpec parser.
- Сохранить все требования, scenarios, статусы, таблицы, ownership и roadmap-границы.
- Подтвердить результат командой `openspec validate --specs --strict`.

**Non-Goals:**

- Изменение смыслового содержания `ASYS-*` или добавление новых requirements.
- Разбиение master-spec на отдельные capability specs.
- Реализация описанных workflow, импорт skills, изменение CLI или пользовательских данных.

## Decisions

1. Добавить `## Purpose` сразу после title/metadata и перед первым содержательным разделом. Purpose кратко объясняет назначение master-spec.
2. Добавить `## Requirements` непосредственно перед разделом, в котором начинаются `### Requirement: ASYS-*`. Все существующие нумерованные разделы до и после requirements сохранить как explanatory/planning context.
3. Не превращать нумерованные разделы в требования и не менять их уровни заголовков без необходимости: validator требует наличие canonical sections и scenarios, но не требует удаления дополнительного контекста.
4. Не создавать delta spec: это format-only documentation/spec normalization. В `.openspec.yaml` change используется `skip_specs: true`, поскольку normative behavior и requirement set не меняются.
5. Проверка должна включать strict baseline validation и targeted structural checks: наличие двух секций, 32 requirement headings и scenario для каждого требования.

Альтернатива — полностью переписать документ в короткий OpenSpec-файл, вынеся master-план в отдельный документ — отклонена: она создаёт риск потери контекста, ссылок и roadmap traceability. Альтернатива — добавить только `## Requirements` — отклонена, поскольку strict validator также требует `## Purpose`.

## Risks / Trade-offs

- [Parser ambiguity] Большой master-документ содержит дополнительные заголовки и таблицы → проверить strict validator после минимального структурного патча.
- [Content drift] При ручном переписывании можно изменить ASYS-требования → ограничить diff добавлением canonical sections и проверить сохранение requirement/scenario inventory.
- [False readiness] Прохождение structural validation не подтверждает реализацию ASYS behavior → явно сохранить статусы `PROPOSED/ROADMAP` и не менять implementation claims.

## Migration Plan

1. Зафиксировать исходный requirement/scenario inventory и текущий failing validation output.
2. Применить минимальный структурный patch к `openspec/specs/zettelkasten-cli-agent/spec.md`.
3. Проверить diff, количество requirements/scenarios и отсутствие изменений в остальных baseline specs.
4. Запустить `openspec validate --specs --strict`; при failure исправлять только parser-структуру.
5. Rollback выполняется удалением добавленных canonical sections; пользовательские данные и runtime state не затрагиваются.

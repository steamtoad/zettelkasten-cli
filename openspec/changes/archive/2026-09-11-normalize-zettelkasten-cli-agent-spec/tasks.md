## 1. Нормализация структуры master-spec

- [x] 1.1 Зафиксировать текущий failing output и inventory: 32 requirement headings `ASYS-001`–`ASYS-032`, 32 `#### Scenario:` blocks и отсутствие `## Purpose`/`## Requirements`; проверить по `rg` до редактирования.
- [x] 1.2 Добавить краткую секцию `## Purpose` после title/metadata master-spec и перед первым содержательным разделом; проверить, что purpose содержит назначение документа и проходит strict structural validation.
- [x] 1.3 Добавить секцию `## Requirements` непосредственно перед первым `### Requirement: ASYS-*`, не изменяя существующие requirements, сценарии, статусы, таблицы и roadmap-текст; проверить минимальный diff.

## 2. Проверка канонического OpenSpec-формата

- [x] 2.1 Проверить, что все `ASYS-001`–`ASYS-032` находятся после `## Requirements`, каждый имеет хотя бы один `#### Scenario:` и ни один requirement/scenario не потерян; сравнить pre/post inventory.
- [x] 2.2 Выполнить `openspec validate --specs --strict` и подтвердить PASS для `spec/zettelkasten-cli-agent` (фактический baseline path — `openspec/specs/zettelkasten-cli-agent/spec.md`).
- [x] 2.3 Выполнить `git diff --check -- openspec/specs/zettelkasten-cli-agent/spec.md` и проверить, что другие baseline specs, implementation, пользовательские данные и runtime state не изменены.

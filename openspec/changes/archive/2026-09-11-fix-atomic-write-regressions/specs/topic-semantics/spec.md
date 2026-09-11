## MODIFIED Requirements

### Requirement: TOPIC-003 — канонический генератор Topic не создаёт активную Topic с пустым :key-topic

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Topic и тематический ключ`.

Текущая реализация Zettelkasten-CLI MUST сохранять следующее подтверждённое поведение: канонический генератор Topic не создаёт активную Topic с пустым `:key-topic:` или с метаданными, противоречащими выбранному тематическому ключу.

Object constructor Topic MUST отклонять пустую строку key-topic и отсутствующий обязательный key-topic до создания destination или изменения существующих файлов, как при standalone CLI, так и при sourced вызове. Ошибка SHALL давать ненулевой статус с диагностикой поля без итогового filename; допустимый непустой ключ SHALL сохраняться буквально. Вызывающий workflow SHALL NOT добавлять activity, связи или запускать editor после отказа constructor.

#### Scenario: TOPIC-003 contract is verified

- **GIVEN** текущий checkout содержит реализацию этой capability
- **WHEN** соответствующий workflow выполняется или проверяется
- **THEN** наблюдаемое поведение SHALL соответствовать requirement
- **AND** regression SHALL считаться validation failure

#### Scenario: Пустой либо отсутствующий ключ при прямом создании

- **GIVEN** snapshots временного ZK_HOME и валидный непустой title
- **WHEN** Topic constructor вызван с пустой строкой key-topic либо без обязательного key-topic, отдельно через CLI и sourced function
- **THEN** каждый вызов возвращает ненулевой статус с указанием key-topic; UUID.adoc не создан, существующие файлы неизменны и filename не напечатан

#### Scenario: Ошибка constructor проходит через workflow

- **GIVEN** creation workflow получает от Topic constructor отказ preflight key-topic
- **WHEN** workflow обрабатывает результат
- **THEN** статус ненулевой; нет новых activity entries, bindings, запуска editor и итогового success-link

#### Scenario: Допустимый ключ сохранён

- **GIVEN** непустой допустимый key-topic с кириллицей и пробелами
- **WHEN** Topic создаётся через constructor и канонический workflow
- **THEN** код 0; документ содержит обязательные metadata и переданный key-topic без подмены; canonical workflow сохраняет согласованность title/description/doclink с ключом

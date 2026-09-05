## ADDED Requirements

### Requirement: FILE-INDEX-001 — Rebuild полностью выводится из исходных файлов

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-index rebuild MUST атомарно создавать полный индекс из текущих .adoc с обязательными metadata и schema/fingerprint. Удаление .state/index SHALL не терять знания; rebuild SHALL не менять источник и исключать partial generation из чтения.

#### Scenario: Индекс удалён

- **GIVEN** старые index files удалены
- **WHEN** выполнен rebuild
- **THEN** индекс восстановлен из notes; metadata/deprecated совпадают с источниками

#### Scenario: Ошибка rebuild

- **GIVEN** scan или запись новой generation отказали
- **WHEN** читатель обращается к индексу
- **THEN** старый complete index либо файловый fallback; partial не используется

### Requirement: FILE-INDEX-002 — Отсутствие или устаревание cache не меняет выдачу

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Search/selectors MUST выдавать семантически тот же набор, что current source scan, при missing/stale/corrupt index. Изменение файла в Vim, delete/rename и deprecated SHALL обнаруживаться fingerprints либо приводить к source fallback.

#### Scenario: Vim меняет deprecated

- **GIVEN** после rebuild активная Note вручную архивирована
- **WHEN** выполнен selector
- **THEN** Note исключена, устаревший cache не возвращает её

#### Scenario: Термин только в body

- **GIVEN** cache хранит metadata, а запрос совпадает лишь с body
- **WHEN** выполнен find/read
- **THEN** результат совпадает с прямым full-text backend

### Requirement: FILE-INDEX-003 — Индекс диагностируется отдельно от источника

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-index check и zt-check MUST диагностировать incompatible schema, повреждение и stale generation как derived-state issue с предложением rebuild. Они SHALL NOT чинить UUID/knowledge metadata через cache; error policy MUST отличать corruption источника от отсутствующего optional cache.

#### Scenario: Cache повреждён

- **GIVEN** индекс содержит malformed entry
- **WHEN** выполнены check и обычный поиск
- **THEN** check сообщает INDEX_CORRUPT; обычный поиск корректно использует файлы

### Requirement: FILE-INDEX-004 — Оптимизация подтверждается семантикой и измерениями

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Изменение search backend MUST сопровождаться equivalence tests и воспроизводимым benchmark с числом документов, размерами, платформой, версиями tools, median timings и числом запусков процессов. Результаты SHALL сравниваться с прямым batch scan; обоснование backend не строится по одному замеру.

#### Scenario: Benchmark

- **GIVEN** подготовлены fixtures 100/1000/10000 с Unicode и deprecated
- **WHEN** измерены scan и cache минимум пять раз
- **THEN** сохранены median и environment; эквивалентность выдачи проходит до оценки скорости

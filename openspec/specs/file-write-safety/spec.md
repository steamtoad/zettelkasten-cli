# file-write-safety Specification

## Purpose

Гарантировать безопасную одиночную замену постоянных файлов, exclusive create и достоверную передачу ошибок записи.

## Requirements

### Requirement: WRITE-SAFE-001 — Существующая цель сохраняется при неуспешной подготовке

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Безопасность файловой записи`.

Файловый writer MUST подготовить и проверить полное новое содержимое до замены существующей цели. Ошибка подготовки SHALL оставлять исходные байты и mode неизменными; ошибка замены SHALL возвращаться вызывающему коду.

#### Scenario: Отказ записи подготовленного файла

- **GIVEN** существует Note с содержимым и mode 0644
- **WHEN** инъекция I/O failure прерывает подготовку добавленной связи
- **THEN** writer возвращает ненулевой код; хеш и mode Note совпадают с исходными

#### Scenario: Успешная замена

- **GIVEN** валидное изменение и writable destination на отдельном от TMPDIR filesystem
- **WHEN** writer применяет изменение
- **THEN** изменены только предусмотренные байты; mode сохранён; временных файлов после успеха нет

### Requirement: WRITE-SAFE-002 — Reduce прекращает выполнение при ошибке любой связи

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Безопасность файловой записи`.

Reduce MUST проверять результат каждого добавления ссылки и каждой записи. После ошибки он SHALL завершаться с ненулевым кодом, без `Reduce complete` и без дальнейшего архивирования. Диагностика MUST перечислять уже затронутые файлы до появления общего recovery.

#### Scenario: Отказ добавления Note linkage

- **GIVEN** подготовлена каноническая Topic и связанная Note с разделом Связи
- **WHEN** операция добавления связи возвращает ошибку
- **THEN** Note не обнулена; старая Topic не архивируется после ошибки; stdout не содержит `Reduce complete`

#### Scenario: Нормальный Reduce

- **GIVEN** все записи успешны
- **WHEN** выполнен Clean Successor
- **THEN** новая Topic и взаимные ссылки существуют; старые предусмотренные объекты архивированы; код 0

### Requirement: WRITE-SAFE-003 — Создание не перезаписывает коллизию

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Безопасность файловой записи`.

Constructors, новый successor Reduce/Refine и Workspace create MUST резервировать новое назначение без перезаписи обычного файла или symlink. При коллизии SHALL возвращаться ошибка без удаления чужого назначения.

#### Scenario: Конкурирующие create

- **GIVEN** два процесса получают одно имя назначения
- **WHEN** они одновременно создают файл
- **THEN** ровно один успешно создаёт объект; другой не меняет и не удаляет его

#### Scenario: Symlink на назначении

- **GIVEN** назначение уже является symlink
- **WHEN** запущен create
- **THEN** операция отклонена, symlink и его цель не изменены

### Requirement: WRITE-SAFE-004 — Ошибка записи передаётся через CLI

**Legacy status:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Безопасность файловой записи`.

Continue, read, binding и creation entrypoints MUST передавать ненулевой результат обязательного чтения или записи; финальные print и запуск редактора SHALL NOT маскировать ошибку.

#### Scenario: Отказ обратной Memo-ссылки

- **GIVEN** создаётся продолжение Memo
- **WHEN** запись обратной связи завершилась ошибкой
- **THEN** CLI завершён с ошибкой и не печатает итоговый success-link

#### Scenario: Ошибка чтения

- **GIVEN** `zt-read` нашёл файл
- **WHEN** `cat` возвращает ошибку чтения
- **THEN** команда завершается ненулевым кодом с указанием файла

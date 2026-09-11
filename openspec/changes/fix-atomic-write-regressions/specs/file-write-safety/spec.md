## MODIFIED Requirements

### Requirement: WRITE-SAFE-001 — Существующая цель сохраняется при неуспешной подготовке

**Baseline legacy status до дельты:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Безопасность файловой записи`.

Файловый writer MUST подготовить и проверить полное новое содержимое до замены существующей цели. Ошибка подготовки SHALL оставлять исходные байты и mode неизменными; ошибка замены SHALL возвращаться вызывающему коду.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

До replace writer MUST определить поддержанность ACL и owner/group цели. Поддержанные ACL/owner/group SHALL сохраняться и проверяться на подготовленном файле; неподдержанная политика или ошибка её определения/воспроизведения SHALL давать явный ненулевой результат до replace. При отказе исходные bytes, mode, ACL и owner/group MUST оставаться неизменными. Отсутствие инструмента определения ACL SHALL NOT трактоваться как отсутствие ACL.

#### Scenario: Отказ записи подготовленного файла

- **GIVEN** существует Note с содержимым и mode 0644
- **WHEN** инъекция I/O failure прерывает подготовку добавленной связи
- **THEN** writer возвращает ненулевой код; хеш и mode Note совпадают с исходными

#### Scenario: Успешная замена

- **GIVEN** валидное изменение и writable destination на отдельном от TMPDIR filesystem
- **WHEN** writer применяет изменение
- **THEN** изменены только предусмотренные байты; mode сохранён; временных файлов после успеха нет

#### Scenario: Цель имеет ACL

- **GIVEN** на временной Note успешно установлен нативный ACL и зафиксированы bytes, mode, ACL, owner/group
- **WHEN** выполняется atomic append
- **THEN** поддержанная политика возвращает 0, добавляет только предусмотренный текст и сохраняет mode, ACL и owner/group
- **AND** неподдержанная политика возвращает ненулевой статус с диагностикой до replace и сохраняет исходную цель полностью

#### Scenario: Ошибка определения или переноса свойств

- **GIVEN** исходная цель существует и инъекция отказывает в определении или воспроизведении её ACL/owner/group
- **WHEN** writer готовит замену
- **THEN** замена не применяется; статус ненулевой, исходные bytes и свойства неизменны

#### Scenario: Обычный файл без ACL

- **GIVEN** обычный writable файл без ACL с поддержанным owner/group
- **WHEN** atomic append завершается успешно
- **THEN** код 0, сохранены исходный текст, mode и owner/group; добавлены только заказанные bytes

### Requirement: WRITE-SAFE-002 — Reduce прекращает выполнение при ошибке любой связи

**Baseline legacy status до дельты:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Безопасность файловой записи`.

Reduce MUST проверять результат каждого добавления ссылки и каждой записи. После ошибки он SHALL завершаться с ненулевым кодом, без `Reduce complete` и без дальнейшего архивирования. Диагностика MUST перечислять уже затронутые файлы до появления общего recovery.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Reduce MUST проверять producer и consumer обязательной подготовки successor, включая Full Copy. Отказ чтения/подготовки SHALL прекращать workflow до публикации невалидного successor и до последующих links, deprecation, editor и success output.

При любой ошибке после первой knowledge-записи диагностика MUST однозначно перечислять созданные/изменённые этой попыткой knowledge-файлы, включая новый или существующий all-todays и ранний отказ successor. Незатронутые кандидаты SHALL NOT перечисляться как изменённые; сохранённые recovery artifacts SHALL указываться отдельно.

#### Scenario: Отказ добавления Note linkage

- **GIVEN** подготовлена каноническая Topic и связанная Note с разделом Связи
- **WHEN** операция добавления связи возвращает ошибку
- **THEN** Note не обнулена; старая Topic не архивируется после ошибки; stdout не содержит `Reduce complete`

#### Scenario: Нормальный Reduce

- **GIVEN** все записи успешны
- **WHEN** выполнен Clean Successor
- **THEN** новая Topic и взаимные ссылки существуют; старые предусмотренные объекты архивированы; код 0

#### Scenario: Full Copy producer завершился с ошибкой

- **GIVEN** валидная Topic с body, связанная Note и сохранённые исходные hashes
- **WHEN** Full Copy producer возвращает ненулевой статус без stdout либо после частичного stdout
- **THEN** Reduce возвращает ненулевой статус; не публикует невалидный successor, не добавляет последующие связи и не архивирует исходные документы
- **AND** editor не запускается; stdout не содержит Reduce complete и итогового success-link; уже затронутые knowledge-файлы перечислены

#### Scenario: Успешный Full Copy

- **GIVEN** валидная Topic с body и все обязательные операции успешны
- **WHEN** выполнен Full Copy
- **THEN** successor имеет корректные обязательные metadata, UUID v1 и сохранённый body; предусмотренные взаимные ссылки и deprecation существуют; exit 0

#### Scenario: Журнал изменён до ошибки Note linkage

- **GIVEN** отдельные fixtures с существующим и с отсутствующим all-todays за текущую дату
- **WHEN** Reduce успешно записывает activity и затем получает ошибку Note linkage
- **THEN** exit ненулевой; список изменённых knowledge-файлов совпадает с snapshot diff, включая журнал, successor и уже изменённую старую Topic
- **AND** Note остаётся неизменной и дальнейшего архивирования нет

#### Scenario: Ранний отказ после создания журнала

- **GIVEN** all-todays за текущую дату отсутствует и destination successor принадлежит другой операции
- **WHEN** Reduce создаёт журнал, но exclusive create successor получает коллизию
- **THEN** exit ненулевой; чужое назначение сохранено, новый журнал перечислен как затронутый; неизменённые Topic и Note не объявлены изменёнными

### Requirement: WRITE-SAFE-003 — Создание не перезаписывает коллизию

**Baseline legacy status до дельты:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Безопасность файловой записи`.

Constructors, новый successor Reduce/Refine и Workspace create MUST резервировать новое назначение без перезаписи обычного файла или symlink. При коллизии SHALL возвращаться ошибка без удаления чужого назначения.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Гарантия сохранности чужого назначения MUST действовать и в вызывающем workflow, включая cleanup/rollback. Refine SHALL удалять destination только если он создан этой попыткой и по-прежнему имеет её подтверждённую identity; неуспешная reservation не даёт права удаления. Если identity изменилась, cleanup MUST сохранить текущее назначение и диагностировать конфликт.

#### Scenario: Конкурирующие create

- **GIVEN** два процесса получают одно имя назначения
- **WHEN** они одновременно создают файл
- **THEN** ровно один успешно создаёт объект; другой не меняет и не удаляет его

#### Scenario: Symlink на назначении

- **GIVEN** назначение уже является symlink
- **WHEN** запущен create
- **THEN** операция отклонена, symlink и его цель не изменены

#### Scenario: Refine rollback после коллизии обычного файла

- **GIVEN** валидная исходная Topic, выбранная Note и существующий чужой файл по UUID будущего successor
- **WHEN** Refine получает ошибку exclusive create и выполняет rollback
- **THEN** CLI возвращает ненулевой статус без Refine complete; чужие bytes/mode сохранены, файл не удалён

#### Scenario: Refine rollback после коллизии symlink

- **GIVEN** отдельные fixtures с live и dangling symlink по имени будущего successor
- **WHEN** Refine получает отказ reservation и выполняет rollback
- **THEN** каждый symlink и буквальная link target сохранены, существующая цель live symlink неизменна; exit ненулевой

#### Scenario: Конкурент появился после preflight

- **GIVEN** preflight Refine не обнаружил destination
- **WHEN** другой процесс создаёт его до reservation и Refine продолжает apply/rollback
- **THEN** Refine возвращает ошибку и не меняет или удаляет чужое назначение

#### Scenario: Identity destination изменилась перед rollback

- **GIVEN** Refine создал собственный successor, затем другая операция заменила этот pathname своим файлом
- **WHEN** ошибка последующей записи запускает rollback
- **THEN** текущее чужое назначение сохранено, ошибка identity диагностирована, exit ненулевой

#### Scenario: Обычный Refine без коллизии

- **GIVEN** валидная Topic и выбранные документы, destination свободен и все записи успешны
- **WHEN** Refine применяет изменение
- **THEN** successor создан, предусмотренные связи и журнал согласованы, stdout содержит итоговый link и exit равен 0

### Requirement: WRITE-SAFE-004 — Ошибка записи передаётся через CLI

**Baseline legacy status до дельты:** `INVARIANT`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Безопасность файловой записи`.

Continue, read, binding и creation entrypoints MUST передавать ненулевой результат обязательного чтения или записи; финальные print и запуск редактора SHALL NOT маскировать ошибку.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Creation entrypoints MUST проверять ошибки generator/producer, даже если consumer получил EOF и завершился успешно, а также ошибки preflight обязательных полей. Последующие print внутри command group SHALL NOT скрывать отказ producer; CLI и sourced constructor SHALL возвращать ошибку без итогового filename/success-link.

#### Scenario: Отказ обратной Memo-ссылки

- **GIVEN** создаётся продолжение Memo
- **WHEN** запись обратной связи завершилась ошибкой
- **THEN** CLI завершён с ошибкой и не печатает итоговый success-link

#### Scenario: Ошибка чтения

- **GIVEN** `zt-read` нашёл файл
- **WHEN** `cat` возвращает ошибку чтения
- **THEN** команда завершается ненулевым кодом с указанием файла

#### Scenario: Metadata producer ошибся до завершения command group

- **GIVEN** object constructor получает валидные arguments, но metadata producer выдаёт часть header и возвращает ненулевой статус
- **WHEN** выполняется создание
- **THEN** constructor возвращает ошибку; не публикует невалидный документ и не печатает итоговый filename
- **AND** вызывающий creation workflow не запускает editor и не печатает success-link

#### Scenario: Consumer записи нового документа отказал

- **GIVEN** валидный prepared document и инъекция ошибки записи destination
- **WHEN** создание вызывается через CLI
- **THEN** статус ненулевой, editor не запускается, итогового success-link нет; чужие destinations не меняются и не удаляются

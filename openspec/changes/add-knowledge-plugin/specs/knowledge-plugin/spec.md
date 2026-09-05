## Purpose

Определяет отдельный Knowledge plugin и sibling-каталог `knowledge/` для локальных AsciiDoc reference-документов, которые могут иметь проверяемые двусторонние связи с Note/Memo, но не принадлежат core document model Zettelkasten.

## ADDED Requirements

### Requirement: KNOW-ARCH-001 — Knowledge является отдельным sibling plugin
Zettelkasten-CLI SHALL размещать canonical Knowledge create/link/check workflow и plugin-specific документацию под `.scripts/knowledge/`. Knowledge plugin MUST оставаться вне ownership `.scripts/zettelkasten/`; `.scripts/lib/`, `.scripts/objects/`, `.scripts/zettelkasten/` и другие sibling plugins MUST NOT зависеть от `.scripts/knowledge/`.

#### Scenario: Каноническое владение Knowledge workflow
- **WHEN** определяется реализация создания, связывания или проверки Knowledge reference
- **THEN** canonical workflow находится под `.scripts/knowledge/`, а top-level script содержит только compatibility delegation

#### Scenario: Проверка направления зависимостей
- **WHEN** repository boundary check анализирует executable source references
- **THEN** Knowledge plugin зависит только от собственного кода и domain-neutral `.scripts/lib/`, а обратные зависимости существующих слоёв отсутствуют

### Requirement: KNOW-COMPAT-001 — Knowledge имеет стабильные публичные entrypoints
`.scripts/zt-knowledge-create.zsh`, `.scripts/zt-knowledge-link.zsh` и `.scripts/zt-knowledge-check.zsh` SHALL быть публичными executable compatibility entrypoints, делегировать одноимённым canonical workflow Knowledge plugin через `exec`, передавать `"$@"` и сохранять stdout, stderr и exit status.

#### Scenario: Публичная команда делегирует plugin
- **WHEN** пользователь запускает поддерживаемый `zt-knowledge-*` entrypoint
- **THEN** wrapper передаёт все arguments соответствующему workflow `.scripts/knowledge/`, и его exit status/output возвращаются без подмены

### Requirement: KNOW-DATA-001 — Knowledge хранится рядом с notes и не является core document type
Knowledge plugin MUST хранить управляемые reference-документы непосредственно в `ZK_HOME/knowledge/`, который является sibling для `ZK_HOME/notes/`. Reference MUST быть regular AsciiDoc file с suffix `.adoc`, но MUST NOT требовать UUID filename или core attributes `:type:`, `:key-topic:`, `:deprecated:`, `:doclink:` и `:docfilename:`. Knowledge documents MUST NOT автоматически участвовать в core selectors, Topic binding, Memo Chain, Reduce, Refine, `all-todays`, Workspace или root index.

#### Scenario: Knowledge reference отделён от core model
- **WHEN** create workflow создаёт справочный документ
- **THEN** файл находится непосредственно в `knowledge/`, имеет `.adoc` suffix и AsciiDoc title, но не объявляется Note/Memo/Todo/Diary/Topic и не регистрируется в core workflows

#### Scenario: Существующие core documents сохраняют layout
- **WHEN** Knowledge plugin устанавливается или выполняется
- **THEN** существующие UUID documents остаются непосредственно в `notes/`, а plugin не перемещает и не переклассифицирует их

### Requirement: KNOW-CREATE-001 — Create безопасно создаёт человекочитаемый reference
Knowledge create workflow MUST принимать непустой title, получать из него безопасный человекочитаемый basename `.adoc`, создавать новый file только внутри `ZK_HOME/knowledge/` и открывать его configured editor. Workflow MUST отклонять path traversal, separators, reserved/empty basename, collision, non-regular target и symlink escape до изменения пользовательских данных; cancel MUST завершаться без создания файла.

#### Scenario: Успешное создание reference
- **WHEN** пользователь задаёт допустимый title, для которого target отсутствует
- **THEN** plugin создаёт `knowledge/<safe-name>.adoc` с соответствующим AsciiDoc title и передаёт точный path editor

#### Scenario: Небезопасная цель отклонена
- **WHEN** title приводит к traversal, collision, symlink escape или недопустимому basename
- **THEN** workflow возвращает ошибку до записи и не изменяет существующие файлы

#### Scenario: Отмена не оставляет artifact
- **WHEN** пользователь отменяет prompt или передаёт пустой title
- **THEN** новый Knowledge file и временные artifacts не создаются

### Requirement: KNOW-LINK-001 — Note/Memo и Knowledge связываются относительными ссылками в обе стороны
Knowledge link workflow MUST связывать один regular reference непосредственно из `knowledge/` с одной выбранной активной `note` или `memo` непосредственно из `notes/`. В core document SHALL использоваться target `../knowledge/<basename>.adoc`, а в Knowledge document SHALL использоваться target `../notes/<UUID>.adoc`; links MUST разрешаться относительно physical source file.

#### Scenario: Knowledge связывается с активной Memo
- **WHEN** пользователь выбирает допустимые Knowledge reference и активную Memo
- **THEN** Memo получает разрешимую относительную ссылку на Knowledge, а Knowledge получает разрешимую относительную ссылку на UUID Memo

#### Scenario: Knowledge связывается с активной Note
- **WHEN** пользователь выбирает допустимые Knowledge reference и активную Note
- **THEN** оба файла получают взаимные relative links по тем же path rules

#### Scenario: Недопустимый core target отклонён
- **WHEN** выбран target другого `:type:`, deprecated Note/Memo, non-UUID filename, symlink или file вне `notes/`
- **THEN** plugin диагностирует target и не изменяет ни один документ

### Requirement: KNOW-LINK-002 — Двустороннее связывание идемпотентно и атомарно
Knowledge link workflow MUST считать relation существующей по нормализованному target path независимо от link description, не создавать duplicate link или managed heading при повторном запуске и завершать изменение по принципу «обе стороны либо ни одной». File mode обоих документов SHALL сохраняться; после любой ошибки исходное содержимое обоих документов и отсутствие temporary artifacts SHALL быть восстановлены.

#### Scenario: Повторное связывание не создаёт дубликаты
- **WHEN** workflow повторно получает ту же пару Note/Memo и Knowledge
- **THEN** каждый document содержит ровно одну plugin-managed ссылку на другую сторону и один соответствующий managed section

#### Scenario: Ошибка второй записи откатывает первую
- **WHEN** failure injection делает невозможной подготовку или замену одной стороны
- **THEN** содержимое и mode обоих исходных файлов совпадают с состоянием до запуска, а односторонняя relation отсутствует

### Requirement: KNOW-CHECK-001 — Knowledge checker проверяет boundaries и взаимность managed links
Knowledge checker MUST проверять, что plugin-managed files являются regular `.adoc` непосредственно в `knowledge/`, managed link targets остаются внутри sibling `knowledge/`/`notes/`, существуют и имеют допустимый target kind, а каждая plugin-managed Note/Memo↔Knowledge relation взаимна. Broken, escaping, symlinked, type-invalid, deprecated или one-sided relation MUST приводить к non-zero exit и точной диагностике source и target; валидный Vault SHALL завершаться с zero exit.

#### Scenario: Валидные двусторонние ссылки проходят проверку
- **WHEN** все managed Knowledge relations взаимны, разрешимы и соответствуют boundaries/type rules
- **THEN** `zt-knowledge-check.zsh` завершается успешно

#### Scenario: Односторонняя или выходящая за boundary ссылка обнаружена
- **WHEN** managed relation имеет отсутствующую обратную сторону либо target выходит из `knowledge/` или `notes/`
- **THEN** checker завершается с ошибкой и сообщает source file и проблемный target

### Requirement: KNOW-SAFE-001 — Development не изменяет реальный Vault
Implementation и validation Knowledge plugin MUST использовать временный `ZK_HOME`. Установка и ordinary repository checks MUST NOT сканировать, создавать, перемещать или изменять пользовательские `knowledge/` и `notes/`; `knowledge/` MAY создаваться только явным runtime create workflow.

#### Scenario: Integration test изолирован
- **WHEN** запускается Knowledge integration test
- **THEN** create/link/check, cancel, collision, traversal, symlink, idempotency и rollback scenarios выполняются только внутри временного `ZK_HOME`

#### Scenario: Установка не мигрирует данные
- **WHEN** версия с Knowledge plugin устанавливается или обновляется
- **THEN** существующие пользовательские files не читаются, не перемещаются и не переписываются автоматически


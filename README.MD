# Zettelkasten-CLI

**Русский** | **English**

---

# Русский

Нормативный baseline требований: `openspec/specs/*/spec.md`. Legacy stable-ID traceability: `scripts/docs/requirements.adoc` и `scripts/{zettelkasten,diary,inbox,workspace}/docs/requirements.adoc`.

## Описание

Zettelkasten-CLI — это попытка сделать систему управления знаниями настолько простой, насколько это вообще возможно.

Здесь нет собственного формата хранения, сложной внутренней структуры или обязательного графического интерфейса. Есть обычный каталог с текстовыми файлами, Git и набор shell-скриптов, которые автоматизируют рутинную работу.

Проект построен вокруг нескольких простых идей:

* знания должны храниться локально;
* заметки должны оставаться обычными текстовыми файлами;
* Git лучше встроенной истории изменений;
* shell лучше скрытой автоматизации;
* UUID никогда не должен меняться.

В основе проекта лежат:

* AsciiDoc;
* Git;
* zsh;
* Vim;
* философия Unix.

Все основные документы хранятся в виде обычных файлов:

```text
UUID.adoc
```

UUID одновременно является:

* идентификатором документа;
* именем файла;
* целью внутренних ссылок.

---

## Модель знаний

В основе системы лежит простая цепочка:

```text
Topic
   └── Memo
          └── Note
```

### Topic

Ключевая тема предметной области.

Она определяет направление развития знаний и объединяет связанные документы.

### Memo

Рабочая заметка.

Memo накапливает материалы, идеи и промежуточные выводы.

### Note

Законченная единица знания.

Note считается наиболее устойчивым типом документа и обычно переживает несколько поколений Topic.

---

## Развитие знаний

Со временем Topic начинают разрастаться.

Вместо бесконечного редактирования старой темы система использует операцию **Reduce**.

Reduce создаёт новое поколение Topic, сохраняя историю развития предметной области.

Во время Reduce:

* создаётся новая Topic;
* старая Topic становится deprecated;
* связанные Memo становятся deprecated;
* Note остаются активными;
* активные Note автоматически связываются с новой Topic;
* поколения Topic связываются ссылками:

```text
Развитие:
Основано на:
```

После повторных Reduce в предметной области остаётся одна активная Topic, а вся история сохраняется внутри хранилища.

---

## Поиск и интерактивный выбор

`zt-find.zsh` и `zt-read.zsh` выполняют регистронезависимый поиск буквальной строки по всему активному документу, включая body. `zt-edit.zsh`, `zt-getlink.zsh` и специализированные selectors показывают `UUID.adoc - description` и ищут по `:description:`; точный basename и fingerprint передаются отдельно от отображаемого текста.

Отмена `fzf` не изменяет Vault. Отсутствующая зависимость, ошибка selector или изменение выбранной цели после показа завершают команду диагностикой до mutation. Во всех workflow `ZK_HOME` имеет приоритет; для Inbox `ZETTELKASTEN_ROOT` остаётся совместимым fallback.

---

## Агентная система разработки

Разработка repository теперь использует ту же specification-driven схему, что и English Reading Lab:

```text
AGENTS.MD
    ↓
repo-local dev/skills/zettelkasten-* (Marta)
    ↓
OpenSpec baseline + scripts + tests
    ↓
legacy stable-ID traceability + Feature List
```

Семь development skills разделяют implementation, OpenSpec changes, script review, system review, validation, migration и release. Общие operational contracts хранятся в `dev/scripts/docs/skill-contracts/`; drift skills и coverage OpenSpec проверяются через `dev/scripts/zt-agent-skills-check.zsh` и `dev/scripts/zt-openspec-check.zsh`. Интеграционные проверки development agent должны использовать временный `ZK_HOME`, а не пользовательские документы.

Старый путь `scripts/dev/*` больше не поддерживается; development scripts
вызываются из `dev/scripts/*`. Совместимый silent fallback не предоставляется.

## Управляемые runtime-навыки

Существующий operational слой пользовательских managed skills сохраняется отдельно и не заменяется skills Marta.

Для runtime-операций используется трёхуровневая модель authority и связанная с ней
история пояснительных редакций:

```text
AGENTS.MD
        ↓
managed operational zettelkasten-* dev/skills
        ↓
scripts + requirements
        ↘
        подробные Note revisions
```

Каждый top-level `zt-*.zsh` имеет собственный управляемый OpenClaw-навык.
Исторический каталог `.agent-skills` сохранён только как read-only архив и не
участвует в runtime routing.

Managed skills находятся вне Git-репозитория. Совместимая с текущим checkout
редакция фиксируется в `scripts/docs/managed-skills.adoc` и проверяется через
`zt-skills-review.zsh`. Интерактивные creation scripts являются механическим
reference для agent workflow, но до появления `zcreate --no-edit` не считаются
unattended deterministic primitives.

При изменении поведения создаётся новая редакция подробной Note, а предыдущая переводится в состояние `:deprecated:`.

Таким образом сам проект развивается теми же механизмами, которыми развивается пользовательская база знаний.


# English

Normative requirements baseline: `openspec/specs/*/spec.md`. Legacy stable-ID traceability remains in `scripts/docs/requirements.adoc` and `scripts/{zettelkasten,diary,inbox,workspace}/docs/requirements.adoc`.

## Description

Zettelkasten-CLI is an attempt to keep knowledge management as simple as possible.

There is no proprietary storage format, mandatory graphical interface, or hidden internal structure. The repository is just a directory with plain text files, Git history, and a collection of shell scripts that automate routine work.

The project is built around a few simple ideas:

* knowledge should remain local;
* notes should remain plain text;
* Git is better than built-in history;
* shell is better than hidden automation;
* UUIDs should never change.

The system is based on:

* AsciiDoc;
* Git;
* zsh;
* Vim;
* the Unix philosophy.

Every main document is stored as:

```text
UUID.adoc
```

A UUID is simultaneously:

* the document identifier;
* the filename;
* the target of internal links.

---

## Knowledge Model

The core structure is intentionally simple:

```text
Topic
   └── Memo
          └── Note
```

Topic represents a domain.

Memo accumulates working material.

Note represents durable knowledge and is expected to survive multiple Topic generations.

---

## Knowledge Evolution

As Topics grow, they eventually become difficult to maintain.

Instead of endlessly rewriting them, the system provides the **Reduce** operation.

Reduce creates a successor Topic while preserving the complete history of the domain.

Old Topics and related Memo become deprecated, Notes remain active, and active Notes are automatically linked to the new Topic.

This allows the knowledge base to evolve without losing its past.

---

## Search and interactive selection

`zt-find.zsh` and `zt-read.zsh` perform case-insensitive literal full-content search, including document bodies. `zt-edit.zsh`, `zt-getlink.zsh`, and specialized selectors display `UUID.adoc - description` and search descriptions; the exact basename and fingerprint are carried separately from display text.

Cancelling `fzf` leaves the Vault unchanged. A missing dependency, selector failure, or target changed after display stops the command before mutation. `ZK_HOME` takes precedence throughout; Inbox retains `ZETTELKASTEN_ROOT` as a compatibility fallback.

---

## Development Agent System

Repository development now follows the same specification-driven pattern as English Reading Lab:

```text
AGENTS.MD
    ↓
repo-local dev/skills/zettelkasten-* (Marta)
    ↓
OpenSpec baseline + scripts + tests
    ↓
legacy stable-ID traceability + Feature List
```

Seven development skills separate implementation, OpenSpec changes, script review, system review, validation, migration, and release. Shared operational contracts live under `dev/scripts/docs/skill-contracts/`; `dev/scripts/zt-agent-skills-check.zsh` and `dev/scripts/zt-openspec-check.zsh` detect skill drift and OpenSpec coverage regressions. Development integration tests use a temporary `ZK_HOME` rather than user knowledge documents.

The former `scripts/dev/*` path is no longer supported; development scripts are
invoked from `dev/scripts/*`. No silent compatibility fallback is provided.

## Managed Runtime Skills

The existing user-facing operational managed-skill layer remains separate and is not replaced by Marta's development skills.

It follows a three-level authority model with an adjacent explanatory revision
history:

```text
AGENTS.MD
        ↓
managed operational zettelkasten-* dev/skills
        ↓
scripts + requirements
        ↘
        detailed Note revisions
```

Every top-level `zt-*.zsh` script has one managed OpenClaw skill. The historical
`.agent-skills` directory is retained only as a read-only archive and is not
part of runtime routing.

Managed skills live outside the Git repository. The revision compatible with
the current checkout is recorded in `scripts/docs/managed-skills.adoc` and
verified by `zt-skills-review.zsh`. Interactive creation scripts are mechanical
references for agent workflows, but are not unattended deterministic primitives
until `zcreate --no-edit` exists.

When behaviour changes, a new detailed Note revision is created and the previous one becomes deprecated.

The project therefore evolves using the same mechanisms that it uses for knowledge management.

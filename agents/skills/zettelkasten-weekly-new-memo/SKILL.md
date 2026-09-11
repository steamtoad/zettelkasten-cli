---
name: "zettelkasten-weekly-new-memo"
description: "Сохраняет недельный обзор новых notes/*.adoc как связанный Memo в notes/."
---

# Zettelkasten Weekly New Memo

Готовить недельный обзор новых материалов из `~/zettelkasten` с разбивкой по темам и сохранять обзор как новый AsciiDoc Memo в `~/zettelkasten/notes/`.

Этот скилл похож на `zettelkasten-weekly-new`, но не выводит полный обзор в чат. Он создаёт Memo и отвечает кратким отчётом о созданном файле.

## Жесткие ограничения

- Читать, искать и писать только внутри `~/zettelkasten`.
- Не использовать веб, память, почту, календари, GitHub API, Obsidian vaults вне `~/zettelkasten` или любые другие внешние источники.
- Не изменять исходные статьи/заметки, из которых строится обзор.
- Не предлагать правки к статьям, переименования, новые заметки или улучшения структуры, если пользователь явно не попросил.
- Разрешённые записи: новый Memo, сегодняшняя запись `all-todays/YYYY-MM-DD.adoc`, и точечные обратные ссылки в 2-5 активных связанных документах согласно правилам Zettelkasten.
- Не связывать новый Memo с deprecated-документами.
- Если подходящий недельный Memo за текущую дату уже существует, не создавать дубль: показать ссылку на существующий файл и спросить пользователя только если он явно хочет новую версию.

## Перед созданием

Перед записью прочитать как источник истины:

- `/Users/steamtoad/zettelkasten/.scripts/zt-memo.zsh`;
- `/Users/steamtoad/zettelkasten/.scripts/lib/asciidoc.zsh`;
- `/Users/steamtoad/zettelkasten/.scripts/lib/paths.zsh`;
- `/Users/steamtoad/zettelkasten/.scripts/lib/uuid.zsh`;
- при необходимости `zettelkasten-theme-capture` правила, если они доступны в текущей среде.

Следовать текущему формату metadata, UUID, `all-todays` и связей. Если интерактивный `zt-memo.zsh` непригоден для автоматического запуска, создать файл вручную по его формату.

## Как найти новые материалы

Работать как `zettelkasten-weekly-new`.

1. Проверить Git-добавления за последние 7 дней:

```bash
git -C ~/zettelkasten log --since='7 days ago' --diff-filter=A --name-only --pretty=format: -- 'notes/*.adoc'
```

2. Учесть незакоммиченные новые `.adoc`:

```bash
git -C ~/zettelkasten status --short -- 'notes/*.adoc'
```

Брать строки `?? path.adoc` как новые незакоммиченные файлы.

3. Использовать `find ~/zettelkasten/notes -maxdepth 1 -type f -name '*.adoc' -mtime -7` только как запасной сигнал. Если `mtime` возвращает много старых заметок с давними `:date:` и без Git-добавления за окно, считать `mtime` шумным и явно опираться на Git-добавления плюс untracked-файлы.

4. Объединить результаты, убрать дубли, оставить относительные пути от корня `~/zettelkasten`.

## Что не включать в обзор

Не включать в итоговый Memo служебные топики и индексные страницы, даже если они новые:

- файлы с `:type: topic`;
- заголовки вида `... - ключевая тема`;
- `all-todays/YYYY-MM-DD.adoc`;
- другие очевидные индексные/навигационные страницы, если они не являются содержательной статьей или memo.

Их можно использовать только как вспомогательный сигнал для группировки.

## Как читать и группировать

Для каждого найденного содержательного файла прочитать только нужные части:

- заголовок AsciiDoc: первая строка `= ...`;
- атрибуты `:author:`, `:generated-at:`, `:date:`, `:type:`, `:keywords:`, `:key-topic:`;
- первые смысловые абзацы;
- ссылки `link:...[]` и заметные разделы.

Классифицировать по содержанию, а не только по имени файла. Темы выбирать компактно: 3-8 групп обычно достаточно. Если материал многотемный, поместить его в самую сильную тему и при необходимости отметить вторичную связь в одной короткой фразе.

## Формат создаваемого Memo

Создать UUID v1 core document как `~/zettelkasten/notes/UUID.adoc`.

Заголовок:

```asciidoc
= Memo - Что нового в Zettelkasten за последнюю неделю от DD-MM-YYYY
```

Metadata:

```asciidoc
:date: YYYY-MM-DD
:generated-at: YYYY-MM-DD
:keywords: memo, zettelkasten, weekly-review, knowledge-map
:type: memo
:author: marta
:description: Memo - Что нового в Zettelkasten за последнюю неделю от DD-MM-YYYY
:doclink: link:UUID.adoc[Memo - Что нового в Zettelkasten за последнюю неделю от DD-MM-YYYY]
:docfilename: UUID.adoc
:key-topic: Zettelkasten
```

Если key topic `Zettelkasten` не найдена или deprecated, выбрать ближайшую активную key topic по смыслу и указать её в `:key-topic:`.

Тело Memo оформлять только в AsciiDoc:

```asciidoc
== Кратко

За последние 7 дней в `~/zettelkasten` найдено N новых содержательных материалов.
Служебные топики и индексные страницы скрыты.

== Тема 1

* link:relative-path.adoc[Название] -- коротко, о чем заметка.
* link:relative-path.adoc[Название] -- коротко, о чем заметка.

== Тема 2

* link:relative-path.adoc[Название] -- коротко, о чем заметка.

== Метод

Смотрела только `~/zettelkasten`: Git-добавления за 7 дней, незакоммиченные новые `.adoc` и, при необходимости, `mtime` как запасной сигнал.

== Связи

* Topic: link:topic-file.adoc[Название topic]
* Memo: link:related-memo.adoc[Название связанного memo]
```

Правила:

- Внутри Memo использовать notes-relative ссылки `link:UUID.adoc[Название]`.
- Не использовать абсолютные пути.
- Не использовать Markdown-ссылки, Markdown-заголовки или fenced code blocks в создаваемом Memo.
- Не включать рекомендации или предложения правок.

## Регистрация и связи

После создания Memo:

1. Зарегистрировать его в сегодняшнем `all-todays/YYYY-MM-DD.adoc`:

```asciidoc
* HH.MM - link:../notes/UUID.adoc[Memo - Что нового в Zettelkasten за последнюю неделю от DD-MM-YYYY]
```

2. Добавить двустороннюю связь Memo ↔ key topic.
3. Найти 2-5 активных документов с сильным смысловым совпадением и добавить двусторонние ссылки без дублей.
4. Не связывать только по общему слову `zettelkasten`; связь должна быть содержательной: недельный обзор, knowledge map, тематические кластеры, AI/Zettelkasten-инструменты или близкая обзорная функция.

## Проверка

После создания выполнить:

```bash
zsh ~/zettelkasten/.scripts/zt-check.zsh
git -C ~/zettelkasten diff --check
```

Также проверить вручную:

- у Memo есть `:date:`, `:generated-at:`, `:keywords:`, `:type: memo`, `:author: marta`, `:doclink:`, `:docfilename:`;
- Memo зарегистрирован в `all-todays/YYYY-MM-DD.adoc`;
- все `link:...[]` указывают на существующие относительные файлы;
- обратные ссылки добавлены только в активные, не deprecated документы.

## Ответ пользователю

Не выводить полный обзор в чат. Ответить кратко по-русски:

- созданный Memo: `link:notes/UUID.adoc[Название]`;
- key topic;
- добавленные кросс-ссылки;
- результат проверок `zt-check` и `git diff --check`;
- если были уже существующие незакоммиченные изменения, упомянуть, что они не трогались.

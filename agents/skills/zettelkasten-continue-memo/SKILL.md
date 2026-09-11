---
name: "zettelkasten-continue-memo"
description: "Создаёт связанное продолжение Memo с двусторонней навигацией."
---

# Zettelkasten Continue Memo

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/4a3fa38c-a0c6-11f1-a087-cbe3683c07ab.adoc`.

Использовать, когда пользователь явно просит создать продолжение существующего активного Memo.

## Источники

- `.scripts/zt-continue.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/uuid.zsh`
- `.scripts/lib/asciidoc.zsh`

## Процедура

1. Работать с активными Memo внутри `notes/`; deprecated Memo исключать.
2. Выбрать исходное Memo и получить его `:keywords:` и необязательный `:key-topic:`.
3. Создать UUID v1 Memo как `notes/UUID.adoc` с каноническим заголовком и унаследованными metadata.
4. Добавить в новое Memo ссылку `Предыдущее memo` на источник.
5. Если у источника нет следующего Memo, добавить `Следующее memo`; иначе добавить отдельную ссылку `Ветка: ...`.
6. Зарегистрировать новое Memo в `all-todays`.
7. Проверить обе навигационные ссылки, UUID, metadata, Asciidoctor, `.scripts/zt-check.zsh` и `git diff --check`.

Отмена выбора или ввода не должна создавать документ.

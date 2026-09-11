---
name: "zettelkasten-inbox-capture"
description: "Безопасно создаёт raw capture в inbox/raw без постоянного документа."
---

# Zettelkasten Inbox Capture

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/4a40099e-a0c6-11f1-99b3-f39780652151.adoc`.

## Когда использовать

Использовать, когда пользователь просит быстро сохранить необработанную мысль или входящий материал в staging-слой Zettelkasten, не создавая постоянную Note или Memo.

## Источники истины

- `/Users/steamtoad/zettelkasten/.scripts/zt-inbox.zsh`
- `/Users/steamtoad/zettelkasten/.scripts/docs/inbox.adoc`
- требования `INBOX-001`–`INBOX-012`
- feature list, раздел `Inbox Layer`

## Предварительные проверки

1. Убедиться, что запрос относится к raw capture, а не к постоянной Note/Memo.
2. Проверить существование и исполняемость `.scripts/zt-inbox.zsh`.
3. Определить корень через `ZK_HOME`; не менять рабочий корень без необходимости.
4. Заголовок должен быть непустым и однострочным.
5. Не считать raw-файл источником истины и не добавлять его в `all-todays`.

## Процедура

1. Запустить:
   ```zsh
   ZK_HOME=/Users/steamtoad/zettelkasten EDITOR=/usr/bin/true \
     /Users/steamtoad/zettelkasten/.scripts/zt-inbox.zsh "Заголовок"
   ```
2. Считать stdout путём созданного raw-файла.
3. Проверить, что путь находится непосредственно в `inbox/raw/`.
4. При необходимости редактирования человеком не переопределять `EDITOR`; скрипт откроет файл сам.
5. Не преобразовывать capture в постоянный документ без отдельного запроса.

## Побочные эффекты

- создаётся каталог `inbox/raw`, если его нет;
- создаётся один timestamp-файл с `:captured-at:` и `:source: manual`;
- файл может открыться через `$EDITOR`;
- постоянные документы и `all-todays` не меняются.

## Проверка результата

- файл существует и не перезаписал прежний;
- первая строка является AsciiDoc-заголовком;
- `:captured-at:` и `:source:` идут непосредственно после заголовка;
- stdout содержит фактический путь;
- `zsh -n .scripts/zt-inbox.zsh` проходит.

## Ограничения и ошибки

- отклонять пустой и многострочный заголовок;
- не обходить ошибку отсутствующего редактора;
- не создавать raw-файл вручную, если скрипт доступен;
- не объявлять Inbox-import реализованным: поддерживается только staging capture.

---
name: "zettelkasten-inbox-processed"
description: "Атомарно переводит один raw capture в inbox/processed без перезаписи."
---

# Zettelkasten Inbox Processed

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/4a4072bc-a0c6-11f1-b288-c77ba383e0e9.adoc`.

## Когда использовать

Использовать, когда пользователь явно подтверждает, что конкретный элемент `inbox/raw` обработан и его нужно перевести в `inbox/processed`.

## Источники истины

- `/Users/steamtoad/zettelkasten/.scripts/zt-processed.zsh`
- `/Users/steamtoad/zettelkasten/.scripts/docs/inbox.adoc`
- требования `INBOX-001`–`INBOX-012`
- feature list, раздел `Inbox Layer`

## Предварительные проверки

1. Разрешить точный source-файл read-only.
2. Убедиться, что это непосредственный обычный файл `inbox/raw`, не каталог, вложенный путь или symlink наружу.
3. Убедиться, что пользователь действительно просит изменить staging-состояние.
4. Проверить отсутствие файла с тем же именем в `inbox/processed`.
5. Не выполнять массовую обработку по glob без отдельного явного запроса.

## Процедура

1. Запустить с basename или точным полным путём:
   ```zsh
   ZK_HOME=/Users/steamtoad/zettelkasten \
     /Users/steamtoad/zettelkasten/.scripts/zt-processed.zsh FILE
   ```
2. Считать stdout путём processed-файла.
3. Проверить, что source исчез, destination появился, имя и содержимое сохранены.
4. Сообщить пользователю точный перемещённый файл.

## Побочные эффекты

- создаются `inbox/raw` и `inbox/processed`, если отсутствуют;
- source удаляется только после атомарного резервирования destination hard link;
- постоянные Note/Memo и `all-todays` не меняются.

## Проверка результата

- destination находится непосредственно в `inbox/processed`;
- destination не существовал до операции;
- source больше не существует;
- содержимое и имя сохранены;
- `zsh -n .scripts/zt-processed.zsh` проходит.

## Ограничения и ошибки

- raw и processed должны быть на одной файловой системе;
- существующий destination не перезаписывать и не удалять автоматически;
- внешний, вложенный и symlink-путь отклонять;
- если source неоднозначен, остановиться и запросить точный файл;
- processed означает завершение staging-обработки, а не импорт в постоянный Zettelkasten.

# Основание change: проверка 2026-09-06

## Область и достоверность

Проверено рабочее дерево `zettelkasten-cli` поверх HEAD `cf4611d4f203a52298e128b29bac676d11adc973`, включая незакоммиченную реализацию `fix-atomic-document-writes`; macOS / Darwin 25.6.0. Это failure evidence до исправления, не verification будущей реализации.

OpenSpec 60/60, основные atomic/LF tests и полный suite прошли. Шесть дополнительных fixtures выявили пять defects ниже. Исходный checkout не изменялся (339 file hashes/modes и Git status совпали). Linux и отдельный от TMPDIR filesystem не проверялись.

## Общий синтетический fixture

Создать временный ZK_HOME с notes/ и all-todays/. Исходная Topic `10000000-0000-1000-8000-000000000000.adoc` имеет type=topic, key-topic=Atomic, title/description `Atomic - ключевая тема` и согласованные остальные обязательные атрибуты. Note `10000001-0000-1000-8000-000000000000.adoc` имеет type=note, key-topic=Atomic и раздел `== Связи`. Provider uuid/uuidgen возвращает `20000000-0000-1000-8000-000000000000`; fzf stub выбирает эти документы и явно заданный режим; vim stub возвращает 0.

Все stubs ограничены PATH дочерней команды во временном fixture. Сравниваются snapshots до/после; реальные документы не используются.

| Fixture | Действие и инъекция | Наблюдение до исправления | Требование |
|---|---|---|---|
| Refine regular collision | Заранее создать по новому UUID файл `FOREIGN DOCUMENT`; выбрать новую линию New Line, Note, не архивировать source, подтвердить Refine | exit 1; существующий файл удалён rollback | WRITE-SAFE-003 |
| Refine symlink collision | По новому UUID создать symlink на отдельный synthetic файл; выполнить тот же Refine | exit 1; symlink удалён, его target сохранён | WRITE-SAFE-003 |
| Reduce Full Copy read failure | Только awk с аргументом `new_fname=...` возвращает 74 без stdout; остальные awk делегируются реальному executable | exit 0; Reduce complete; старая Topic deprecated; successor без type=topic | WRITE-SAFE-002/004 |
| ACL replacement | На synthetic Note добавить macOS ACL `everyone allow read`; вызвать zk_append_text_atomic | exit 0; числовой mode сохранён, ACE исчезла после rename | WRITE-SAFE-001 |
| Empty Topic key | Вызвать object constructor с аргументами `Title` и пустой строкой | exit 0; создан UUID.adoc с пустым key-topic. На HEAD: exit 1, ERROR :key-topic: is empty | TOPIC-003 |
| Incomplete recovery list | При Reduce Clean Successor отказать только mv на связанную Note после успешной записи журнала | exit 1; all-todays содержит successor link, но отсутствует в Already changed files | WRITE-SAFE-002 |

ACL `ls -le` может отображать субъект UUID `ABCDEFAB-CDEF-ABCD-EFAB-CDEF0000000C`; тест должен сравнивать ACE/ACL, а не ожидать буквальное слово everyone в выводе.

## Пробелы старого primary test

- Concurrency/symlink проверяются на уровне writer helper; Refine rollback не выполняется.
- Проверяется Clean Successor; отказ producer Full Copy отсутствует.
- Проверяются bytes/mode; ACL/ownership не проверяются.
- Recovery-list проверяется по наличию заголовка, а не по множеству реально изменённых файлов.
- Runtime constructor suite использует валидные arguments и пропускает регрессию пустого key-topic.

Новые тесты не должны объявлять PASS лишь по наличию helper names или Requirement/Scenario text. Валидные сценарии и ошибочные выходы проверяются отдельно.

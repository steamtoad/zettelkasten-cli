# Задачи реализации и проверки

Этот change подготовлен как спецификация. Ниже все задачи будущей реализации; создание файлов change не закрывает их.

## 1. Контракт и failing fixtures

- [x] 1.1 Сверить текущие `WRITE-SAFE-001…004`, `TOPIC-003` и predecessor; зафиксировать source snapshot и список пяти mismatch из evidence.md.
- [x] 1.2 Создать primary test `tests/zt-fix-atomic-write-regressions.zsh` во временном ZK_HOME; перенести шесть воспроизведений пяти дефектов из evidence.md в observable assertions и подтвердить ожидаемые FAIL до fixes.
- [x] 1.3 Дополнить fixtures частичным stdout producer, late collision, rollback чужой identity, валидным Full Copy, обычным файлом без ACL, отказом проверки/переноса ACL и existing/new all-todays; сопоставить каждый Scenario в specs с assertion.

## 2. Исправление пяти дефектов

- [x] 2.1 WRITE-SAFE-003: устранить безусловное удаление чужого Refine destination; учитывать успешную reservation и identity при cleanup/rollback. Проверить regular/live symlink/dangling symlink и конкурентное появление.
- [x] 2.2 WRITE-SAFE-002/004: завершать проверяемую подготовку Full Copy до создания successor; распространять статусы producer и consumer, прерывать последующие links/deprecation/editor/success output при отказе.
- [x] 2.3 WRITE-SAFE-001: реализовать и документировать поддержанную ACL/ownership policy, проверять свойства до replace; обеспечить сохранение либо явный отказ без изменения цели. Сохранить mode/bytes и обычный путь без ACL.
- [x] 2.4 TOPIC-003/WRITE-SAFE-004: восстановить общий preflight обязательных Topic полей для create/write; отклонять пустой ключ до записи при standalone и sourced вызове; проверить допустимый непустой ключ без его изменения.
- [x] 2.5 WRITE-SAFE-002: перечислять все уже затронутые knowledge-файлы, включая создание/обновление all-todays и ранний отказ successor; сравнить recovery-list с фактическим snapshot diff.

## 3. Регрессия и платформы

- [x] 3.1 Запустить primary test, подключить его к tests/zt-all.zsh; повторить predecessor atomic test, runtime-core, Refine/Reduce/Workspace и plugin boundary tests, затем полный suite. LF test сохраняет PASS.
- [x] 3.2 Подтвердить валидный Clean Successor/Full Copy и Refine; проверить status/stdout/stderr, links/deprecated, modes, отсутствие лишних временных файлов, cancel и сохранность посторонних fixtures.
- [x] 3.3 Проверить macOS/Linux и root paths с пробелами/Unicode; ACL fixtures создавать нативными средствами. Если capability тестовой среды недоступна, записать причину SKIP и не объявлять её проверенной. Если ACL fixture успешно создан, проверка runtime policy обязательна и не может стать SKIP.
- [x] 3.4 Проверить destination на отдельном от TMPDIR filesystem при наличии fixture; иначе явно записать непроверенное ограничение. Выполнить zsh -n изменённых shell-файлов, git diff --check и zt-check на валидном временном Vault.

## 4. Синхронизация и evidence

- [x] 4.1 Сохранить результаты сценариев и платформенные ограничения в verification.md; отличить исправленные пять defects от неподтверждённых гарантий общих транзакций/ownership/platforms.
- [x] 4.2 Синхронизировать пять требований в baseline, соответствующие legacy формулировки и подтверждённый Feature List; не дублировать IDs и не повышать ROADMAP по факту локального patch.
- [x] 4.3 Обновить недостоверную archive-readiness/verification оценку `fix-atomic-document-writes` с учётом повторной проверки; исторические evidence не стирать. Не считать подготовку этой дельты исправлением predecessor.
- [x] 4.4 Выполнить `openspec validate --all --strict --no-interactive`, `dev/scripts/zt-openspec-check.zsh` и `tests/zt-openspec-archive-contract.zsh`; проверить merged preview predecessor → correction без потери старых/новых scenarios и без last-writer-wins.
- [x] 4.5 Подтвердить отсутствие unresolved behavior/spec conflicts и готовность к последующей отдельной операции archive. Не выполнять commit/tag/push, archive или миграцию автоматически.

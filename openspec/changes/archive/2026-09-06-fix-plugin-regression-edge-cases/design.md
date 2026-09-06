## Decisions

1. Capture резервирует и записывает файл в subshell с cwd=raw: sysopen получает ASCII basename вместо Unicode полного пути, но сохраняет O_EXCL. Родительский cwd и stdout path сохраняются. Отдельные статусы различают коллизию, отказ создания и ошибку записи. Shell lexical quoting редактора снимается через Zsh Q без eval.
2. Processed проверяет symlink leaf до physical resolution. POSIX utility `link` выполняет точный hard link call: в отличие от `ln` существующий каталог не превращается в directory operand. Utility проверяется до изменения файлов; missing dependency — явная ошибка. Same-filesystem invariant и cleanup после ошибки удаления raw сохраняются.
3. Workspace разбирает link macros за пределами opaque blocks. Удаляется только выбранный macro; пустая после удаления bullet line убирается целиком. Другая ссылка/текст сохраняются byte-for-byte. Temp file создаётся в каталоге Workspace для same-filesystem rename и убирается при неуспехе.
4. Статический checker не выполняет shell. Он рекурсивно анализирует command substitutions и shell compound segments; unsupported вычисляемые source dependencies отклоняются. Bare relative source зависит от runtime cwd/search path, поэтому требует explicit directory anchor. Документы и quoted literal examples не являются dependency.

## Verification

Сначала новые edge fixtures должны воспроизвести failures исходной реализации; после patch они проходят. Проверяются источник/назначение, содержимое соседних документов, atomic destination collisions, literal editor arguments, cleanup, negative dependency fixtures и все существующие тесты. Реальный Vault не используется. Linux/macOS claims ограничены реально выполненными проверками; отсутствие Linux runtime не скрывается.

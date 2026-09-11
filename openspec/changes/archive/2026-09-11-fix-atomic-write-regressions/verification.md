# Verification

Date: 2026-09-11

## Source snapshot and corrected mismatches

Implementation started from HEAD `d594972a495309abbac83d5a13b685896c15898d`.
Pre-change SHA-256:

- `scripts/lib/asciidoc.zsh`: `1d5051a0b15237287795bc8b9b71e929b7f6a9056d6d4c5dec7ff571567dd6b8`
- `scripts/zt-refine.zsh`: `b6141a330b0b47a003844582eecd10bf1c8a6665d6c47bdefa3bef036bd92e37`
- `scripts/zt-reduce.zsh`: `860b2c11f8315a391ac73395712c690da157761b85c78999d3ad8856eb31da01`
- `scripts/objects/topic-create.zsh`: `7a08d2ae138b9f3d704777f7a55c3b7f6ba468548c9fcaab87167e78aa9451aa`

Пять воспроизведённых mismatch из `evidence.md` исправлены:

1. Refine rollback больше не удаляет destination после неуспешной reservation и проверяет сохранённую file identity перед cleanup собственного successor.
2. Full Copy сначала завершает и валидирует producer output, затем выполняет file-based exclusive create; empty/partial producer failure не публикуется.
3. Atomic replacement проверяет mode, owner/group и ACL state до replace. Обычный файл без ACL поддержан; ACL-bearing и требующие owner/group transfer цели явно отклоняются без изменения.
4. Standalone и sourced `zk_topic_create` выполняют общий title/key-topic preflight до создания `notes/` и destination.
5. Reduce recovery-list учитывает созданный либо обновлённый `all-todays`, successor и остальные фактически изменённые knowledge-файлы без failed destination.

## Executable evidence

- `tests/zt-fix-atomic-write-regressions.zsh`: PASS. Проверены regular/live/dangling/late Refine collisions, changed identity before rollback, normal Refine, Full Copy empty/partial producer failure и success, existing/new `all-todays`, metadata producer failure, standalone/sourced empty Topic key, literal Unicode key и root paths с пробелами/Unicode.
- Нативный macOS ACL fixture создан успешно: runtime policy вернула ненулевой статус до replace и сохранила bytes/mode/ACL/owner-group.
- `tests/zt-fix-atomic-document-writes.zsh`: PASS.
- `tests/zt-runtime-core.zsh`: PASS с временным `ZK_HOME` и `zt-check`.
- `tests/zt-workspace-as-plugin.zsh`: PASS.
- `dev/scripts/zt-plugin-boundaries-check.zsh`: PASS.
- `tests/zt-fix-script-ending-idempotency.zsh`: PASS.
- `tests/zt-all.zsh`: PASS; optional live Marta routing smoke test SKIP согласно runner contract.
- Changed-file `zsh -n`: PASS.

## Platform and scope limits

- Проверено на macOS Darwin 25.6.0 arm64.
- Linux runtime/ACL fixture: NOT-RUN в этой среде; Linux path использует `stat -c`, `ls -ld` и опциональный test fixture через `setfacl/getfacl`, но не объявляется подтверждённым.
- Writable destination на отдельной от `TMPDIR` filesystem: NOT-RUN — `/tmp`, OpenClaw tmp, checkout и доступные writable roots находятся на одном `/System/Volumes/Data`; `/dev/shm` отсутствует. Writer создаёт prepared file рядом с destination, но cross-filesystem scenario не объявляется исполненным.
- ShellCheck доступен, но его Bash parser не понимает канонические Zsh expansions и выдаёт SC2296/SC2298 на валидный Zsh; результат классифицирован как SKIP для semantic lint, `zsh -n` остаётся обязательной проверкой.
- Общие multi-file transactions, SIGKILL recovery, fsync durability, произвольные xattrs/flags и privileged ownership transfer не входят в change и не объявляются реализованными.

## Result

Пять defects закрыты executable regression evidence. Baseline, legacy traceability и Feature List синхронизированы с подтверждённой политикой. Archive readiness зависит от финального OpenSpec/traceability validation и merged-preview проверки обеих atomic-write deltas.

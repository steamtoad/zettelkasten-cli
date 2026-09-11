#!/bin/zsh

#------------------------------------------------------------------------------
# zt-standardize-cli-preflight-and-selection.zsh
# Тип: Runtime Regression Test
# Назначение: проверить общий CLI preflight, selection и processed retry contract
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-cli-preflight.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM

fake_bin="$fixture/bin"
mkdir -p "$fake_bin"

print -rl -- \
  '#!/bin/zsh' \
  'sep=$'"'"'\x1f'"'"'' \
  'case "${ZK_TEST_FZF_MODE:-select}" in' \
  '  cancel) exit 130 ;;' \
  '  error) exit 2 ;;' \
  'esac' \
  'while IFS= read -r line; do' \
  '  identity="${${line#*$sep}%%$sep*}"' \
  '  [[ -z "${ZK_TEST_PICK:-}" || "$identity" == "$ZK_TEST_PICK" ]] || continue' \
  '  case "${ZK_TEST_FZF_MODE:-select}" in' \
  '    delete) rm -f -- "$ZK_HOME/notes/$identity" ;;' \
  '    change) print -r -- changed >> "$ZK_HOME/notes/$identity" ;;' \
  '  esac' \
  '  print -r -- "$line"' \
  '  exit 0' \
  'done' \
  'exit 1' > "$fake_bin/fzf"

print -rl -- \
  '#!/bin/zsh' \
  '[[ -n "${ZK_TEST_EDITOR_MARKER:-}" ]] && print -r -- called > "$ZK_TEST_EDITOR_MARKER"' \
  'exit 0' > "$fake_bin/vim"
chmod +x "$fake_bin/fzf" "$fake_bin/vim"

write_note() {
  local root="$1"
  local fname="$2"
  local description="$3"
  local body="$4"
  local type="${5:-note}"

  mkdir -p "$root/notes"
  print -rl -- \
    "= $description" \
    ':date: 2026-09-11' \
    ":type: $type" \
    ":keywords: $type, regression" \
    ':author: test' \
    ":description: $description" \
    ":doclink: link:${fname}[${description}]" \
    ":docfilename: $fname" \
    '' \
    "$body" > "$root/notes/$fname"
}

file_mode() {
  if stat -f '%Lp' "$1" >/dev/null 2>&1; then
    stat -f '%Lp' "$1"
  else
    stat -c '%a' "$1"
  fi
}

primary_root="$fixture/Vault с пробелами"
other_root="$fixture/Other Vault"
first='10000000-0000-1000-8000-000000000001.adoc'
second='10000001-0000-1000-8000-000000000001.adoc'
description='Unicode — title - with separator'
write_note "$primary_root" "$first" "$description" 'body-only-needle'
write_note "$primary_root" "$second" 'Other description' 'ordinary body'
write_note "$other_root" "$second" 'Decoy' 'must remain unchanged'
other_hash="$(cksum -- "$other_root/notes/$second")"

original_hash="$(cksum -- "$primary_root/notes/$first")"
original_mode="$(file_mode "$primary_root/notes/$first")"
original_files="$(find "$primary_root" -type f -print | LC_ALL=C sort)"

# Missing selector dependency is an error, not cancel, and creates nothing.
if env PATH='/usr/bin:/bin' ZK_HOME="$primary_root" \
  "$repo/scripts/zt-getlink.zsh" > "$fixture/missing.out" 2> "$fixture/missing.err"; then
  print -ru2 -- 'FAIL: missing fzf was reported as success'
  exit 1
fi
rg -qF 'required command not found: fzf' "$fixture/missing.err" || {
  print -ru2 -- 'FAIL: missing fzf diagnostic omitted dependency name'
  exit 1
}

preflight_root="$fixture/preflight mutation"
write_note "$preflight_root" "$first" 'Memo preflight' 'body' memo
if env PATH='/usr/bin:/bin' ZK_HOME="$preflight_root" \
  "$repo/scripts/zt-continue.zsh" > "$fixture/preflight-mutation.out" 2> "$fixture/preflight-mutation.err"; then
  print -ru2 -- 'FAIL: mutating workflow treated missing fzf as success'
  exit 1
fi
[[ ! -e "$preflight_root/all-todays" ]] || {
  print -ru2 -- 'FAIL: missing fzf created a journal directory before preflight'
  exit 1
}

# Invalid Inbox editor is rejected before raw directory or file creation.
invalid_editor_root="$fixture/invalid editor"
if env PATH="$fake_bin:$PATH" ZK_HOME="$invalid_editor_root" EDITOR='' \
  "$repo/scripts/inbox/capture.zsh" 'must not exist' > "$fixture/editor.out" 2> "$fixture/editor.err"; then
  print -ru2 -- 'FAIL: empty EDITOR was accepted'
  exit 1
fi
[[ ! -e "$invalid_editor_root/inbox/raw" ]] || {
  print -ru2 -- 'FAIL: invalid EDITOR created inbox/raw'
  exit 1
}

# Cancel is a clean no-op; an operational fzf failure is not.
env PATH="$fake_bin:$PATH" ZK_HOME="$primary_root" ZK_TEST_FZF_MODE=cancel \
  "$repo/scripts/zt-getlink.zsh" > "$fixture/cancel.out" 2> "$fixture/cancel.err"
[[ ! -s "$fixture/cancel.out" ]] || { print -ru2 -- 'FAIL: cancel printed a link'; exit 1; }
[[ "$(cksum -- "$primary_root/notes/$first")" == "$original_hash" ]] || { print -ru2 -- 'FAIL: cancel changed bytes'; exit 1; }
[[ "$(file_mode "$primary_root/notes/$first")" == "$original_mode" ]] || { print -ru2 -- 'FAIL: cancel changed mode'; exit 1; }
[[ "$(find "$primary_root" -type f -print | LC_ALL=C sort)" == "$original_files" ]] || { print -ru2 -- 'FAIL: cancel changed file set'; exit 1; }

cancel_root="$fixture/cancel mutation"
write_note "$cancel_root" "$first" 'Memo cancel' 'body' memo
cancel_hash="$(cksum -- "$cancel_root/notes/$first")"
env PATH="$fake_bin:$PATH" ZK_HOME="$cancel_root" ZK_TEST_FZF_MODE=cancel \
  "$repo/scripts/zt-continue.zsh" > "$fixture/cancel-mutation.out" 2> "$fixture/cancel-mutation.err"
[[ "$(cksum -- "$cancel_root/notes/$first")" == "$cancel_hash" && ! -e "$cancel_root/all-todays" ]] || {
  print -ru2 -- 'FAIL: mutating workflow cancel changed Vault state'
  exit 1
}

if env PATH="$fake_bin:$PATH" ZK_HOME="$primary_root" ZK_TEST_FZF_MODE=error \
  "$repo/scripts/zt-getlink.zsh" > "$fixture/fzf-error.out" 2> "$fixture/fzf-error.err"; then
  print -ru2 -- 'FAIL: operational fzf error was reported as success'
  exit 1
fi
rg -qF 'fzf failed with exit status: 2' "$fixture/fzf-error.err" || { print -ru2 -- 'FAIL: fzf error diagnostic omitted status'; exit 1; }

# Machine identity survives spaces, Unicode and the visible " - " separator.
selected_link="$(env PATH="$fake_bin:$PATH" ZK_HOME="$primary_root" ZETTELKASTEN_ROOT="$other_root" \
  ZK_TEST_PICK="$first" "$repo/scripts/zt-getlink.zsh")"
[[ "$selected_link" == "link:${first}[${description}]" ]] || { print -ru2 -- 'FAIL: selector parsed display text as identity'; exit 1; }
[[ "$(cksum -- "$other_root/notes/$second")" == "$other_hash" ]] || { print -ru2 -- 'FAIL: core workflow changed fallback root'; exit 1; }

# A target removed or changed after selection is rejected before success output.
delete_root="$fixture/delete target"
write_note "$delete_root" "$first" 'Delete me' 'body'
if env PATH="$fake_bin:$PATH" ZK_HOME="$delete_root" ZK_TEST_FZF_MODE=delete \
  "$repo/scripts/zt-getlink.zsh" > "$fixture/delete.out" 2> "$fixture/delete.err"; then
  print -ru2 -- 'FAIL: deleted selected target was accepted'
  exit 1
fi
rg -qF 'TARGET_NOT_FOUND' "$fixture/delete.err" || { print -ru2 -- 'FAIL: deleted target diagnostic omitted TARGET_NOT_FOUND'; exit 1; }
[[ ! -s "$fixture/delete.out" ]] || { print -ru2 -- 'FAIL: deleted target printed a success link'; exit 1; }

change_root="$fixture/change target"
write_note "$change_root" "$first" 'Change me' 'body'
if env PATH="$fake_bin:$PATH" ZK_HOME="$change_root" ZK_TEST_FZF_MODE=change \
  "$repo/scripts/zt-getlink.zsh" > "$fixture/change.out" 2> "$fixture/change.err"; then
  print -ru2 -- 'FAIL: changed selected target was accepted'
  exit 1
fi
rg -qF 'STATE_CONFLICT' "$fixture/change.err" || { print -ru2 -- 'FAIL: changed target diagnostic omitted STATE_CONFLICT'; exit 1; }

# ZK_HOME wins for Inbox even when ZETTELKASTEN_ROOT points elsewhere.
editor_marker="$fixture/editor-called"
env PATH="$fake_bin:$PATH" ZK_HOME="$primary_root" ZETTELKASTEN_ROOT="$other_root" \
  EDITOR=vim ZK_TEST_EDITOR_MARKER="$editor_marker" \
  "$repo/scripts/inbox/capture.zsh" 'Inbox Unicode — root' > "$fixture/capture.out"
[[ -f "$editor_marker" && -d "$primary_root/inbox/raw" && ! -e "$other_root/inbox" ]] || {
  print -ru2 -- 'FAIL: Inbox did not honor ZK_HOME precedence'
  exit 1
}

# Retry completes only a proven hard-link move; basename collision preserves both.
mkdir -p "$primary_root/inbox/processed"
retry_raw="$primary_root/inbox/raw/retry.adoc"
retry_processed="$primary_root/inbox/processed/retry.adoc"
print -r -- 'same bytes' > "$retry_raw"
ln "$retry_raw" "$retry_processed"
env ZK_HOME="$primary_root" "$repo/scripts/inbox/processed.zsh" retry.adoc > "$fixture/retry.out"
[[ ! -e "$retry_raw" && -f "$retry_processed" && "$(<"$retry_processed")" == 'same bytes' ]] || {
  print -ru2 -- 'FAIL: same-inode processed retry did not finish the move'
  exit 1
}

collision_raw="$primary_root/inbox/raw/collision.adoc"
collision_processed="$primary_root/inbox/processed/collision.adoc"
print -r -- 'raw bytes' > "$collision_raw"
print -r -- 'processed bytes' > "$collision_processed"
if env ZK_HOME="$primary_root" "$repo/scripts/inbox/processed.zsh" collision.adoc > "$fixture/collision.out" 2> "$fixture/collision.err"; then
  print -ru2 -- 'FAIL: different-inode collision was accepted'
  exit 1
fi
[[ "$(<"$collision_raw")" == 'raw bytes' && "$(<"$collision_processed")" == 'processed bytes' ]] || {
  print -ru2 -- 'FAIL: collision did not preserve both files'
  exit 1
}

# find/read remain literal, case-insensitive full-content searches including body.
print -r -- 'BODY-ONLY-NEEDLE' | env ZK_HOME="$primary_root" "$repo/scripts/zt-find.zsh" > "$fixture/find.out"
rg -qF "link:notes/${first}[${description}]" "$fixture/find.out" || { print -ru2 -- 'FAIL: find omitted body-only match'; exit 1; }
print -r -- 'body-only-needle' | env ZK_HOME="$primary_root" "$repo/scripts/zt-read.zsh" > "$fixture/read.out"
rg -qF 'body-only-needle' "$fixture/read.out" || { print -ru2 -- 'FAIL: read omitted body-only match'; exit 1; }

print -r -- 'PASS: CLI preflight, selection identity, paths, processed retry and search'

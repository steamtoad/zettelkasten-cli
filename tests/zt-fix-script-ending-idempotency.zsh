#!/bin/zsh

#------------------------------------------------------------------------------
# zt-fix-script-ending-idempotency.zsh
# Тип: Maintenance Regression Test
# Назначение: проверить read-only lint и идемпотентное исправление последнего LF
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-script-ending.XXXXXX")"
trap 'chmod u+w "$fixture/.scripts/readonly.zsh" 2>/dev/null || true; rm -rf -- "$fixture"' EXIT HUP INT TERM

mkdir -p "$fixture/.scripts/nested"
cp "$repo/.scripts/zt-scripts-patch.zsh" "$fixture/.scripts/zt-scripts-patch.zsh"
print -rn -- $'#!/bin/zsh\nprint good\n' > "$fixture/.scripts/good.zsh"
print -rn -- $'#!/bin/zsh\nprint bad' > "$fixture/.scripts/nested/bad.zsh"
: > "$fixture/.scripts/empty.zsh"
print -rn -- $'#!/bin/zsh\nprint readonly' > "$fixture/.scripts/readonly.zsh"
chmod 0444 "$fixture/.scripts/readonly.zsh"

hash_file() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{ print $1 }'
  else
    sha256sum "$1" | awk '{ print $1 }'
  fi
}

mode_file() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    stat -f '%Lp' "$1"
  else
    stat -c '%a' -- "$1"
  fi
}

good_hash="$(hash_file "$fixture/.scripts/good.zsh")"
bad_hash="$(hash_file "$fixture/.scripts/nested/bad.zsh")"
good_mode="$(mode_file "$fixture/.scripts/good.zsh")"
bad_mode="$(mode_file "$fixture/.scripts/nested/bad.zsh")"
empty_size="$(wc -c < "$fixture/.scripts/empty.zsh" | tr -d '[:space:]')"

if "$fixture/.scripts/zt-scripts-patch.zsh" --check >"$fixture/check.out" 2>"$fixture/check.err"; then
  print -ru2 -- 'FAIL: --check accepted malformed shell files'
  exit 1
fi
rg -qF 'missing LF: nested/bad.zsh' "$fixture/check.err" || {
  print -ru2 -- 'FAIL: --check did not diagnose the missing LF'
  exit 1
}
rg -qF 'empty: empty.zsh' "$fixture/check.err" || {
  print -ru2 -- 'FAIL: --check did not diagnose the empty file'
  exit 1
}
[[ "$(hash_file "$fixture/.scripts/good.zsh")" == "$good_hash" ]] || exit 1
[[ "$(hash_file "$fixture/.scripts/nested/bad.zsh")" == "$bad_hash" ]] || exit 1
[[ "$(mode_file "$fixture/.scripts/good.zsh")" == "$good_mode" ]] || exit 1
[[ "$(mode_file "$fixture/.scripts/nested/bad.zsh")" == "$bad_mode" ]] || exit 1
[[ "$(wc -c < "$fixture/.scripts/empty.zsh" | tr -d '[:space:]')" == "$empty_size" ]] || exit 1

if "$fixture/.scripts/zt-scripts-patch.zsh" >"$fixture/fix.out" 2>"$fixture/fix.err"; then
  print -ru2 -- 'FAIL: fix mode ignored empty/write-failure fixtures'
  exit 1
fi
rg -qF 'patched: nested/bad.zsh' "$fixture/fix.out" || {
  print -ru2 -- 'FAIL: fix mode did not patch the writable file'
  exit 1
}
rg -qF 'ERROR cannot patch: readonly.zsh' "$fixture/fix.err" || {
  print -ru2 -- 'FAIL: fix mode did not report the write failure'
  exit 1
}
! rg -qF 'patched: readonly.zsh' "$fixture/fix.out" || {
  print -ru2 -- 'FAIL: fix mode falsely reported the failed write as patched'
  exit 1
}

bad_after_first="$(hash_file "$fixture/.scripts/nested/bad.zsh")"
[[ "$(tail -c 1 "$fixture/.scripts/nested/bad.zsh" | od -An -tu1 | tr -d '[:space:]')" == 10 ]] || exit 1
[[ "$(hash_file "$fixture/.scripts/good.zsh")" == "$good_hash" ]] || exit 1
[[ "$(mode_file "$fixture/.scripts/good.zsh")" == "$good_mode" ]] || exit 1
[[ "$(mode_file "$fixture/.scripts/nested/bad.zsh")" == "$bad_mode" ]] || exit 1

"$fixture/.scripts/zt-scripts-patch.zsh" >"$fixture/fix2.out" 2>"$fixture/fix2.err" || true
[[ "$(hash_file "$fixture/.scripts/nested/bad.zsh")" == "$bad_after_first" ]] || {
  print -ru2 -- 'FAIL: second fix changed an already-correct file'
  exit 1
}

print -r -- 'PASS: script-ending lint and fixer idempotency'

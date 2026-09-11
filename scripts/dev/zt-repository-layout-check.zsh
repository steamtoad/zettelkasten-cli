#!/bin/zsh

#------------------------------------------------------------------------------
# zt-repository-layout-check.zsh
# Тип: Development Check
# Назначение: проверить preflight и canonical layout repository tooling
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

script_dir="${0:A:h}"
repo_root="${script_dir:h:h}"
mode="${1:---canonical}"

typeset -a protected_paths=(notes all-todays workspaces inbox .last-diary .state)
typeset failures=0

fail() {
  print -u2 -- "ERROR: $*"
  failures=$(( failures + 1 ))
}

check_absent() {
  [[ ! -e "$1" ]] || fail "path must be absent: $1"
}

check_present() {
  [[ -e "$1" ]] || fail "path not found: $1"
}

case "$mode" in
  --preflight)
    check_present "$repo_root/AGENTS.MD"
    check_present "$repo_root/openspec/config.yaml"
    check_present "$repo_root/.scripts/docs/requirements.adoc"
    check_absent "$repo_root/scripts"
    check_absent "$repo_root/dev/skills"
    ;;
  --canonical)
    check_present "$repo_root/AGENTS.MD"
    check_present "$repo_root/openspec/config.yaml"
    check_present "$repo_root/scripts/docs/requirements.adoc"
    check_present "$repo_root/scripts/dev"
    check_present "$repo_root/dev/skills"
    check_absent "$repo_root/.scripts"
    check_absent "$repo_root/skills"
    ;;
  *)
    fail "usage: $0 [--preflight|--canonical]"
    ;;
esac

for protected_path in "${protected_paths[@]}"; do
  if [[ -e "$repo_root/$protected_path" ]] && git -C "$repo_root" status --short -- "$protected_path" | grep -q .; then
    fail "protected user-data path has migration changes: $protected_path"
  fi
done

(( failures == 0 )) || exit 10
print -r -- "PASS: repository layout $mode"

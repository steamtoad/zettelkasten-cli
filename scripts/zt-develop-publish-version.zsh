#!/bin/zsh

#------------------------------------------------------------------------------
# zt-develop-publish-version.zsh
# Тип: Maintenance
# Назначение: публикация версии скриптов, OpenSpec, development skills, tests и документации
#------------------------------------------------------------------------------

emulate -L zsh

script_dir="${0:A:h}"
source "$script_dir/lib/paths.zsh"

src="${ZK_DEV_HOME:-$(zk_home)}"
dst="${ZK_PUBLISH_HOME:-$HOME/dev/zettelkasten-cli}"

apply=0

typeset -a publish_dirs=(scripts dev/scripts openspec dev/skills tests)
typeset -a publish_files=(LICENSE README.MD AGENTS.MD .gitignore)

fail() {
  print -ru2 -- "ERROR $1"
  exit 1
}

case "${1:-}" in
  --apply) apply=1 ;;
  --dry-run|"") apply=0 ;;
  *)
    print -ru2 -- "Usage: zt-develop-publish-version [--dry-run|--apply]"
    exit 1
    ;;
esac

[[ -d "$src" ]] || fail "source not found: $src"
[[ -d "$dst" ]] || fail "destination not found: $dst"

for d in "${publish_dirs[@]}"; do
  [[ -d "$src/$d" ]] || fail "source directory not found: $src/$d"
done

for f in "${publish_files[@]}"; do
  [[ -f "$src/$f" ]] || fail "source file not found: $src/$f"
done

print -r -- "== zt-develop-publish-version"
print -r -- "From: $src"
print -r -- "To:   $dst"
print -r -- ""

mirror_tree() {
  local mode="$1"
  local tree="$2"
  local -a rsync_args

  rsync_args=(-av --delete --delete-excluded --exclude='.DS_Store' --exclude='__MACOSX/')
  [[ "$mode" == dry-run ]] && rsync_args+=(--dry-run)

  rsync "${rsync_args[@]}" "$src/$tree/" "$dst/$tree/" ||
    fail "$mode failed for $tree"
}

copy_root_files() {
  local mode="$1"
  local -a rsync_args sources

  rsync_args=(-av)
  [[ "$mode" == dry-run ]] && rsync_args+=(--dry-run)

  sources=()
  for f in "${publish_files[@]}"; do
    sources+=("$src/$f")
  done

  rsync "${rsync_args[@]}" "${sources[@]}" "$dst/" ||
    fail "$mode failed for root artifacts"
}

if (( apply == 0 )); then
  print -r -- "DRY RUN"
  for d in "${publish_dirs[@]}"; do
    mirror_tree dry-run "$d"
  done
  copy_root_files dry-run
  print -r -- ""
  print -r -- "Run with --apply to copy files."
  exit 0
fi

for d in "${publish_dirs[@]}"; do
  mkdir -p "$dst/$d" || fail "cannot create destination directory: $dst/$d"
  mirror_tree apply "$d"
done
copy_root_files apply

print -r -- ""
print -r -- "Publish copy complete."

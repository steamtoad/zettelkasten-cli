#!/bin/zsh

#------------------------------------------------------------------------------
# zt-migrate-notes-dir.zsh
# Тип: Migration
# Назначение: перенос UUID-документов ядра в notes/ с проверкой входящих ссылок
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob nounset pipefail

script_dir="${0:A:h}"
source "$script_dir/lib/paths.zsh"
source "$script_dir/lib/asciidoc.zsh"

mode="dry-run"
usage() { print -ru2 -- "Usage: ${0:t} [--dry-run|--apply]"; }
die() { print -ru2 -- "ERROR migration: $*"; exit 1; }

case "${1:---dry-run}" in
  --dry-run) mode="dry-run" ;;
  --apply) mode="apply" ;;
  *) usage; exit 1 ;;
esac
(( $# <= 1 )) || { usage; exit 1; }

zk="$(zk_home)"
zk="${zk:A}"
notes_dir="$zk/notes"
[[ -d "$zk" ]] || die "Zettelkasten not found: $zk"

typeset -a documents sources affected_sources moved
typeset -A document_by_abs future_rel_by_source source_seen affected_seen
documents=()
sources=()
affected_sources=()
moved=()
document_by_abs=()
future_rel_by_source=()
source_seen=()
affected_seen=()

work_dir="$(mktemp -d "${TMPDIR:-/tmp}/zt-migrate-notes-plan.XXXXXX")" || die "cannot create planning directory"
rewrites_file="$work_dir/rewrites.tsv"
: > "$rewrites_file"
trap 'rm -rf -- "$work_dir"' EXIT

relative_path() {
  local from_dir="$1" target="$2" ignored
  local -a from_parts target_parts result
  from_parts=("${(@s:/:)${from_dir}}")
  target_parts=("${(@s:/:)${target}}")
  from_parts=("${(@)from_parts:#}")
  target_parts=("${(@)target_parts:#}")
  while (( ${#from_parts} > 0 && ${#target_parts} > 0 )) && [[ "${from_parts[1]}" == "${target_parts[1]}" ]]; do
    from_parts=("${from_parts[@]:1}")
    target_parts=("${target_parts[@]:1}")
  done
  result=()
  for ignored in "${from_parts[@]}"; do result+=(".."); done
  result+=("${target_parts[@]}")
  (( ${#result} > 0 )) || result=(".")
  print -r -- "${(j:/:)result}"
}

add_source() {
  local absolute="${1:A}"
  [[ -n "${source_seen[$absolute]-}" ]] && return 0
  source_seen[$absolute]=1
  sources+=("$absolute")
}

add_affected_source() {
  local absolute="${1:A}"
  [[ -n "${affected_seen[$absolute]-}" ]] && return 0
  affected_seen[$absolute]=1
  affected_sources+=("$absolute")
}

for file in "$zk"/*.adoc; do
  [[ -f "$file" ]] || continue
  case "$(zk_attr_value "$file" type)" in
    note|memo|todo|diary|topic)
      absolute="${file:A}"
      documents+=("$absolute")
      document_by_abs[$absolute]="${file:t}"
      future_rel_by_source[$absolute]="notes/${file:t}"
      add_affected_source "$absolute"
      ;;
  esac
done

while IFS= read -r -d '' file; do add_source "$file"; done < <(
  find "$zk" -type f -name '*.adoc' ! -path "$zk/.git/*" ! -path "$zk/.state/*" ! -path "$zk/.scripts/*" -print0
)

for file in "${sources[@]}"; do
  [[ -n "${future_rel_by_source[$file]-}" ]] || future_rel_by_source[$file]="${file#$zk/}"
  zk_extract_links "$file" > /dev/null || die "unsupported or unclosed opaque block: ${file#$zk/}"
done

for source_file in "${sources[@]}"; do
  source_rel="${source_file#$zk/}"
  future_source="$zk/${future_rel_by_source[$source_file]}"
  while IFS= read -r raw_target; do
    [[ -n "$raw_target" && "$raw_target" != /* ]] || continue
    candidate="${source_file:h}/$raw_target"
    [[ -f "$candidate" ]] || continue
    candidate="${candidate:A}"
    [[ -n "${document_by_abs[$candidate]-}" ]] || continue
    future_target="$notes_dir/${document_by_abs[$candidate]}"
    new_target="$(relative_path "${future_source:h}" "$future_target")" || die "cannot resolve target from $source_rel"
    [[ "$raw_target" == "$new_target" ]] && continue
    print -r -- "$source_file"$'\t'"$raw_target"$'\t'"$new_target" >> "$rewrites_file"
    add_affected_source "$source_file"
  done < <(zk_extract_links "$source_file")
done

for source_file in "${documents[@]}"; do
  destination="$notes_dir/${source_file:t}"
  [[ ! -e "$destination" && ! -L "$destination" ]] || die "destination already exists: $destination"
done

rewrite_count="$(wc -l < "$rewrites_file" | tr -d '[:space:]')"
print -r -- "Mode: $mode"
print -r -- "Root: $zk"
print -r -- "Scan boundary: .adoc under Vault excluding .git, .state and .scripts"
print -r -- "Documents to move: ${#documents[@]}"
print -r -- "Incoming links to rewrite: $rewrite_count"
for source_file in "${documents[@]}"; do print -r -- "MOVE ${source_file:t} -> notes/${source_file:t}"; done
while IFS=$'\t' read -r source_file raw_target new_target; do
  [[ -n "$source_file" ]] && print -r -- "REWRITE ${source_file#$zk/}: link:${raw_target} -> link:${new_target}"
done < "$rewrites_file"

[[ "$mode" == apply ]] || exit 0
if (( ${#documents[@]} == 0 )); then
  print -r -- "No migration work required"
  exit 0
fi
if git -C "$zk" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  [[ -z "$(git -C "$zk" status --porcelain)" ]] || die "working tree must be clean before migration"
fi

stage_dir="$(mktemp -d "${TMPDIR:-/tmp}/zt-migrate-notes-stage.XXXXXX")" || die "cannot create staging directory"
backup_dir="$(mktemp -d "${TMPDIR:-/tmp}/zt-migrate-notes-backup.XXXXXX")" || { rm -rf -- "$stage_dir"; die "cannot create backup directory"; }

rollback() {
  local source_file source_rel destination backup_file
  for source_file in "${documents[@]}"; do
    source_rel="${source_file#$zk/}"
    destination="$notes_dir/${source_file:t}"
    backup_file="$backup_dir/$source_rel"
    [[ -f "$backup_file" ]] || continue
    rm -f -- "$destination"
    cp -p "$backup_file" "$source_file" || true
  done
  for source_file in "${affected_sources[@]}"; do
    [[ -n "${document_by_abs[$source_file]-}" ]] && continue
    source_rel="${source_file#$zk/}"
    backup_file="$backup_dir/$source_rel"
    [[ -f "$backup_file" ]] && cp -p "$backup_file" "$source_file" || true
  done
  rmdir "$notes_dir" 2>/dev/null || true
}

fail_recoverable() {
  rollback
  print -ru2 -- "ERROR RECOVERY_REQUIRED: $1"
  print -ru2 -- "Backup: $backup_dir"
  exit 1
}
trap 'fail_recoverable interrupted' INT TERM HUP

rewrite_file() {
  local source_file="$1" staged_file="$2" source_rel="$3" mode_bits
  mkdir -p "${staged_file:h}" || return 1
  if [[ "${ZK_MIGRATE_TEST_LEAVE_OLD_TARGET:-}" == "$source_rel" ]]; then
    cp -p "$source_file" "$staged_file" || return 1
    return 0
  fi
  awk -F '\t' -v source="$source_file" '
    FILENAME == ARGV[1] { if ($1 == source) replacement[$2] = $3; next }
    function trimmed(value) { sub(/^[[:space:]]+/, "", value); sub(/[[:space:]]+$/, "", value); return value }
    in_block { print; value = trimmed($0); if (block_delim == "```") { if (value ~ /^```/) in_block = 0 } else if (value == block_delim) in_block = 0; next }
    /^```/ { in_block = 1; block_delim = "```"; print; next }
    /^(----|\.{4,}|_{4,}|\*{4,}|={4,}|\+{4,}|\/{4,})[[:space:]]*$/ { in_block = 1; block_delim = trimmed($0); print; next }
    /^:doclink:/ { print; next }
    { line = $0; output = ""; while (match(line, /link:[^[]+\.adoc\[/)) { token = substr(line, RSTART, RLENGTH); target = substr(token, 6, length(token) - 6); output = output substr(line, 1, RSTART - 1); output = output ((target in replacement) ? "link:" replacement[target] "[" : token); line = substr(line, RSTART + RLENGTH) } print output line }
  ' "$rewrites_file" "$source_file" > "$staged_file" || return 1
  mode_bits="$(zk_file_mode "$source_file")" || return 1
  chmod "$mode_bits" "$staged_file"
}

for source_file in "${affected_sources[@]}"; do
  source_rel="${source_file#$zk/}"
  backup_file="$backup_dir/$source_rel"
  mkdir -p "${backup_file:h}" || fail_recoverable "cannot initialize backup"
  cp -p "$source_file" "$backup_file" || fail_recoverable "cannot back up $source_rel"
  staged_file="$stage_dir/${future_rel_by_source[$source_file]}"
  rewrite_file "$source_file" "$staged_file" "$source_rel" || fail_recoverable "cannot stage $source_rel"
done

mkdir -p "$notes_dir" || fail_recoverable "cannot create notes directory"
for source_file in "${documents[@]}"; do
  destination="$notes_dir/${source_file:t}"
  mv "$source_file" "$destination" || fail_recoverable "cannot move ${source_file:t}"
  moved+=("$destination")
done
for source_file in "${affected_sources[@]}"; do
  staged_file="$stage_dir/${future_rel_by_source[$source_file]}"
  if [[ -n "${document_by_abs[$source_file]-}" ]]; then target_file="$notes_dir/${source_file:t}"; else target_file="$source_file"; fi
  zk_replace_from_file_atomic "$target_file" "$staged_file" || fail_recoverable "cannot apply staged file ${source_file#$zk/}"
done

postflight_failed=0
for source_file in "${documents[@]}"; do [[ ! -e "$source_file" && -f "$notes_dir/${source_file:t}" ]] || postflight_failed=1; done
while IFS=$'\t' read -r source_file raw_target new_target; do
  [[ -n "$source_file" ]] || continue
  if [[ -n "${document_by_abs[$source_file]-}" ]]; then target_file="$notes_dir/${source_file:t}"; else target_file="$source_file"; fi
  zk_extract_links "$target_file" | grep -Fx -- "$new_target" >/dev/null || postflight_failed=1
done < "$rewrites_file"
if (( postflight_failed )) || ! "$script_dir/zt-check.zsh" > "$work_dir/postflight.out" 2> "$work_dir/postflight.err"; then
  fail_recoverable "postflight validation failed"
fi

trap - INT TERM HUP
rm -rf -- "$stage_dir" "$backup_dir"
print -r -- "Migration complete: ${#moved[@]} document(s) moved; $rewrite_count incoming link(s) rewritten"

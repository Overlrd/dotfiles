#!/usr/bin/env bash
set -euo pipefail

notes_dir="$HOME/.notes"
upload_script="$HOME/.local/bin/upload-notes.sh"
editor="${EDITOR:-nvim}"

mkdir -p -- "$notes_dir"

# Offer existing Markdown notes and an option to create a new one.
selection="$(
    {
        printf 'New note\n'
        find "$notes_dir" -maxdepth 1 -type f -name '*.md' -printf '%f\n' | sort -f
    } | wmenu -i -l 10 -p 'Notes'
)" || exit 0

[[ -n "$selection" ]] || exit 0

if [[ "$selection" == "New note" ]]; then
    name="$(printf '\n' | wmenu -p 'Note name (blank = timestamp)')" || exit 0
    name="${name%.md}"
    name="${name// /_}"
    name="${name//\//_}"
    name="${name//\\/_}"
    [[ -n "$name" ]] || name="$(date +%F_%H-%M-%S)"
    note_path="$notes_dir/$name.md"
else
    note_path="$notes_dir/$selection"
    [[ -f "$note_path" ]] || exit 1
fi

foot -e "$editor" "$note_path"

# Preserve the existing optional Mega backup after editing.
if [[ -x "$upload_script" ]]; then
    "$upload_script" &
fi

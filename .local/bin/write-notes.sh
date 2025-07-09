#!/usr/bin/env bash
DMENU_COLORS="-nb #181818 -nf #BBBBBB -sb #2C3E50 -sf #FFFFFF"
TERM="alacritty"
EDITOR="nvim"
FOLDER="$HOME/.notes/"
UPLOAD_SCRIPT="$HOME/.local/bin/upload-notes.sh"

newnote () {
  name=$(echo "" | dmenu $DMENU_COLORS -p "Enter a name: ") || exit 0
  : "${name:=$(date +%F_%T | tr ':' '-')}"
  "$TERM" -e nvim "$FOLDER$name.md"
  "$UPLOAD_SCRIPT" &
}

selected () {
  choice=$(printf "New\n%s" "$(ls -t1 "$FOLDER")" | dmenu $DMENU_COLORS -p "Choose note or create new: ") || exit 0
  case "$choice" in
    New) newnote ;;
    *.md) 
      "$TERM" -e nvim "$FOLDER$choice"
      "$UPLOAD_SCRIPT" &
      ;;
    *) exit ;;
  esac
}

selected

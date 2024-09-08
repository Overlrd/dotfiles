#!/bin/sh
grep -v '^#' $BOOKMARKS | dmenu -i -l 50 | cut -d' ' -f1 | xclip -selection clipboard

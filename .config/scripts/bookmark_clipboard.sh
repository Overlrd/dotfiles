#!/bin/sh

bookmark="$(xclip -o)"
file="$HOME/.bookmarks.txt"

if [ ! -f "$file" ]; then
    > $file
else
    if grep -q "^$bookmark$" "$file"; then
        notify-send "Oops!" "bookmark already exist"
    else
        echo "$bookmark" >> "$file"
        notify-send "Saved!" "New bookmark added."
    fi
fi

#!/bin/bash

create_note() {
    local title="$1"
    local tags="${2:-personal}"
    local timestamp=$(date +"%Y-%m-%d")
    local base_filename=$(echo "$title" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    local year=$(date +%Y)
    local month=$(date +%m)
    local dir="$HOME/notes/$year/$month"
    local filename=""
    local suffix=0

    # Create directory if it doesn't exist
    mkdir -p "$dir"

    # Check if a file with the same name already exists
    if [ -f "$dir/$base_filename.md" ]; then
        # If file already exists, offer to open or create a new one
        echo "A file with a similar name already exists:"
        ls -l "$dir/$base_filename"*

        # Using 'select' for a simpler, more interactive prompt
        echo "Do you want to:"
        select choice in "Open existing file" "Create new file" "Quit"; do
            case "$choice" in
            "Open existing file")
                $EDITOR "$dir/$base_filename.md"
                return
                ;;
            "Create new file")
                # Continue with creating a new file (increment suffix)
                break
                ;;

            *)

                echo "Cancelled."
                return
                ;;
            esac
        done
    fi

    # Generate a unique filename with suffix (if needed)
    while true; do
        if [ $suffix -eq 0 ]; then
            filename="$dir/$base_filename.md"
        else
            filename="$dir/$base_filename-$suffix.md"
        fi

        # If file doesn't exist, break the loop
        if [ ! -f "$filename" ]; then
            break
        fi

        # If file exists, increment suffix
        ((suffix++))
    done

    # Create the new note
    cat >"$filename" <<EOF
---
date: $timestamp
tags: [$tags]
---

# $title

EOF

    echo "Note created: $filename"
    $EDITOR "$filename"
}

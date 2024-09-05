#!/bin/sh

BROWSER="firefox" 
BOOKMARKS="$HOME/.bookmarks" 

# Check if the necessary command-line tools are available
for cmd in xdotool xclip notify-send; do
    if ! command -v "$cmd" > /dev/null; then
        echo "Error: Required command '$cmd' is not installed." >&2
        exit 1
    fi
done

# Find the window ID of the currently focused browser window
window_id=$(xdotool search --onlyvisible --class "$BROWSER" | head -n 1)

if [ -n "$window_id" ]; then
   # Get the window name
    window_name=$(xdotool getwindowname "$window_id")

    if [ -z "$window_name" ]; then
        notify-send "Oops!" "Failed to get the window name."
        exit 1
    fi

    # activate the window and  get the url of the focused tab
    xdotool windowactivate "$window_id" key --clearmodifiers ctrl+l ctrl+c Escape
    tab_url="$(xclip -o -selection clipboard)"

    if [ -z "$tab_url" ]; then
        notify-send "Oops!" "Failed to get the tab URL."
        exit 1
    fi
else
    notify-send "Oops!" "No $BROWSER window is active"
    exit 1
fi

# check if bookmarks file exists
if [ ! -e "$BOOKMARKS" ]; then
    > "$BOOKMARKS"
fi

bookmark="$tab_url | $window_name" 

if grep -q "^$bookmark$" $BOOKMARKS ; then
    notify-send "Oops!" "$window_name is already bookmarked"
    exit 1;
else
    echo "$bookmark" >> $BOOKMARKS
    notify-send "Added!" "$window_name has been bookmarked!"
fi

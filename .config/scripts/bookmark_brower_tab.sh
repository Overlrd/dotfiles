#!/bin/sh

# Find the window ID of the currently focused Brave window
window_id=$(xdotool search --onlyvisible --class "$BROWSER" | head -n 1)

if [ -n "$window_id" ]; then
   # Get the window name
    window_name=$(xdotool getwindowname "$window_id")

    # get the url of the focused tab
    xdotool windowactivate "$window_id" key --clearmodifiers ctrl+l ctrl+c Escape
    tab_url="$(xclip -o -selection clipboard)"
else
    notify-send "Oops!" "No $BROWSER window is active"
    exit 1
fi

# check if bookmarks file exist
if [ ! -e "$BOOKMARKS" ]; then
    > "$BOOKMARKS"
fi

bookmark="$tab_url | $window_name" 

if grep -q "^$bookmark$" $BOOKMARKS ; then
    notify-send "Oops!" "$window_name already bookmarked"
    exit 1;
else
    echo "$bookmark" >> $BOOKMARKS
fi

notify-send "Added!" "$window_name Bookmarked!"

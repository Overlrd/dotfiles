#!/bin/bash
# Take a screenshot with scrot
# sudo apt install scrot libnotify-bin uuid
# if not already installed

camera_shutter_sound="/usr/share/sounds/freedesktop/stereo/camera-shutter.oga"
output_file="$HOME/Pictures/$(date '+%Y.%m.%d')-$(uuid).png"

# Create the Pictures directory if it does not exist
if [ ! -d "$HOME/Pictures" ]; then
    mkdir -p "$HOME/Pictures"
fi

# Take a screenshot of the active window
if scrot -u "$output_file"; then
    paplay "$camera_shutter_sound"
    notify-send "Picture saved!" "Your screenshot has been saved to $output_file."
else
    notify-send "Something went wrong!" "Failed to capture the screenshot."
fi

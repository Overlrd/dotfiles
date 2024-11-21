#!/bin/bash
# Take a screenshot with scrot and provide notifications
# Dependencies: scrot, libnotify-bin, paplay, uuid, xfce4-screenshooter
# Ensure dependencies are installed: sudo apt install scrot libnotify-bin paplay uuid

# Configuration
SAVE_DIR="$HOME/Pictures/Screenshots/"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
FILE_NAME="screenshot_$TIMESTAMP.png"
OUTPUT_FILE="$SAVE_DIR/$FILE_NAME"
CAMERA_SHUTTER_SOUND="/usr/share/sounds/freedesktop/stereo/camera-shutter.oga"

# Ensure the directory exists
mkdir -p "$SAVE_DIR"

# Capture the active window using scrot
if scrot -u "$OUTPUT_FILE"; then
    # Play shutter sound
    if [[ -f "$CAMERA_SHUTTER_SOUND" ]]; then
        paplay "$CAMERA_SHUTTER_SOUND"
    fi

    # Send success notification
    notify-send "Screenshot Saved!" "Your screenshot has been saved to:\n$OUTPUT_FILE" -i "$OUTPUT_FILE"
else
    # Send error notification
    notify-send "Screenshot Failed!" "An error occurred while capturing the screenshot."
fi


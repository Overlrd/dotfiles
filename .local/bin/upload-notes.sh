#!/usr/bin/env bash

# Configuration
NOTES_DIR="$HOME/.notes"
MEGA_REMOTE="mega:"
MEGA_FOLDER="Notes"
LOGFILE="$HOME/.notes/backup.log"

# Start clean log
echo "Backup started at $(date)" > "$LOGFILE"

# Check internet connection by pinging default gateway
GATEWAY=$(ip r | awk '/default/ {print $3}')
if ping -q -w 1 -c 1 "$GATEWAY" > /dev/null; then
    echo "Internet connection OK." >> "$LOGFILE"
else
    echo "No internet connection. Aborting." >> "$LOGFILE"
    exit 1
fi

# Send start notification
notify-send "Notes Backup" "Starting backup to Mega..." -i cloud-upload

# Upload and log output
if rclone copy "$NOTES_DIR" "$MEGA_REMOTE$MEGA_FOLDER" >> "$LOGFILE" 2>&1; then
    notify-send "Notes Backup" "Backup completed successfully!" -i cloud-upload
    echo "Upload complete!" >> "$LOGFILE"
else
    notify-send "Notes Backup" "Backup failed! Check logs." -i dialog-error
    echo "Upload failed!" >> "$LOGFILE"
    exit 1
fi

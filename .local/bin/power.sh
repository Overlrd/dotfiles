#!/usr/bin/env bash

# Set dmenu colors to match the i3wm theme
DMENU_COLORS="-nb #181818 -nf #BBBBBB -sb #2C3E50 -sf #FFFFFF"

case "$(printf "Kill Process\nLock\nSuspend\nReboot\nShutdown" | dmenu -i -l 5 $DMENU_COLORS)" in
    "Kill Process")
        # Display list of processes and allow the user to kill one
        ps -u $USER -o pid,comm,%cpu,%mem | dmenu -i -l 10 -p Kill: $DMENU_COLORS | awk '{print $1}' | xargs -r kill
        ;;
    "Lock")
        # Lock the screen and suspend the system with a sleep interval
        i3lock -b -f -k -c F5F5F5 --nofork
        ;;
    "Suspend")
        # Suspend the system
        loginctl suspend
        ;;
    "Reboot")
        # Reboot the system
        loginctl reboot
        ;;
    "Shutdown")
        # Shutdown the system
        loginctl poweroff
        ;;
    *)
        exit 1
        ;;
esac

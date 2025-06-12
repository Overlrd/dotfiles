#!/bin/zsh
pkill mako 2>/dev/null
mako &
notify-send "Mako configuration updated!"

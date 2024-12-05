#!/bin/bash

# Set wallpaper
feh --bg-fill $HOME/.config/wallpaper.png &

# Start Redshift for color temperature adjustment
redshift -l $LAT:$LONG &

# Start network manager applet
nm-applet &

# Start the compositor for transparency and effects
picom &

# Start Mailspring with the appropriate password store
mailspring --password-store='gnome-libsecret' &

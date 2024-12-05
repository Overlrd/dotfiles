#!/bin/bash

# Set wallpaper
feh --bg-fill $HOME/.config/wallpaper.png &

# Start Redshift for color temperature adjustment
redshift -l $LAT:$LONG -t 6500:3400 &

# Start network manager applet
nm-applet &

# Start the compositor for transparency and effects
picom --experimental-backends &

# Start Mailspring with the appropriate password store
mailspring --password-store='gnome-libsecret' &

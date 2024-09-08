img=/tmp/i3lock.png

scrot -o $img
convert -scale 10% -blur 0x0.8 -resize 1000% $img $img

#feh $img
i3lock -i $img

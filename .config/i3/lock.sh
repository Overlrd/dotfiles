#!/bin/sh

BLANK='#00000000'
CLEAR='#282a36'
DEFAULT='#50fa7b'
TEXT='#f8f8f2'
WRONG='#ff5555'
VERIFYING='#ffb86c'

i3lock \
	--insidever-color=$CLEAR \
	--ringver-color=$VERIFYING \
	\
	--insidewrong-color=$CLEAR \
	--ringwrong-color=$WRONG \
	\
	--inside-color=$BLANK \
	--ring-color=$DEFAULT \
	--line-color=$BLANK \
	--separator-color=$DEFAULT \
	\
	--verif-color=$TEXT \
	--wrong-color=$TEXT \
	--time-color=$TEXT \
	--date-color=$TEXT \
	--layout-color=$TEXT \
	--keyhl-color=$WRONG \
	--bshl-color=$WRONG \
	\
	--screen 1 \
	--blur 9 \
	--clock \
	--indicator \
	--time-str="%H:%M:%S" \
	--date-str="%A, %Y-%m-%d" \
	--keylayout 1

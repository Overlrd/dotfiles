#!/bin/sh
# Invoked with sh from Sway, so no executable-bit or PATH setup is required.
# Actions run even when notifications are unavailable.
notify() {
    notify-send -a "Desktop" -t 2000 "$1" "$2" >/dev/null 2>&1 || :
}
fail() {
    notify "Desktop action failed" "$1"
    exit 1
}
sway_command() {
    result=$(swaymsg -r "$1" 2>&1) || return 1
    case "$result" in
        *'"success": false'*|*'"success":false'*) return 1 ;;
    esac
}
case "$1" in
    pointers-off|pointers-on)
        state=disabled
        [ "$1" = pointers-on ] && state=enabled
        sway_command "input \"2:8:AlpsPS/2_ALPS_DualPoint_Stick\" events $state" ||
            fail "Could not change the ALPS stick."
        sway_command "input \"2:8:AlpsPS/2_ALPS_DualPoint_TouchPad\" events $state" ||
            fail "Could not change the ALPS touchpad; the stick may already be $state."
        notify "Internal pointers $state" "Super+Ctrl+F9 disables; Super+Ctrl+F10 restores."
        ;;
    volume-up|volume-down|mute|mic-mute)
        target=@DEFAULT_AUDIO_SINK@
        title="Output audio"
        case "$1" in
            volume-up) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
            volume-down) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
            mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
            mic-mute)
                target=@DEFAULT_AUDIO_SOURCE@
                title="Microphone"
                pactl set-source-mute @DEFAULT_SOURCE@ toggle
                ;;
        esac || fail "Could not change audio. Check PipeWire."
        status=$(LC_ALL=C wpctl get-volume "$target" 2>/dev/null) ||
            fail "Audio changed, but its current state could not be read."
        # wpctl reports a fractional volume and an optional [MUTED] marker.
        body=$(printf '%s\n' "$status" | awk '{printf "%.0f%%", $2 * 100; if ($3 == "[MUTED]") printf " — muted"}')
        notify "$title" "$body"
        ;;
    brightness-up|brightness-down)
        device=intel_backlight
        maximum=$(brightnessctl -d "$device" max) || fail "Cannot read backlight maximum."
        current=$(brightnessctl -d "$device" get) || fail "Cannot read backlight brightness."
        case "$maximum:$current" in
            *[!0-9:]*|:*|*:) fail "Invalid backlight values." ;;
        esac
        [ "$maximum" -gt 0 ] || fail "Invalid backlight maximum."
        # Raw-device arithmetic: 5% steps, rounded up, with a 5% floor.
        step=$(( (maximum + 19) / 20 ))
        next=$((current - step))
        [ "$1" = brightness-up ] && next=$((current + step))
        [ "$next" -lt "$step" ] && next=$step
        [ "$next" -gt "$maximum" ] && next=$maximum
        brightnessctl -q -d "$device" set "$next" ||
            fail "Cannot set brightness. Check backlight permissions."
        actual=$(brightnessctl -d "$device" get) || fail "Cannot read new brightness."
        notify "Brightness" "$(( (actual * 100 + maximum / 2) / maximum ))%"
        ;;
    screenshot-area)
        # Escape in slurp cancels without changing the clipboard.
        geometry=$(slurp) || exit 0
        [ -n "$geometry" ] || exit 0
        shot=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/sway-shot.XXXXXX") ||
            fail "Cannot create temporary screenshot."
        trap 'rm -f -- "$shot"' 0
        trap 'exit 1' HUP INT TERM
        grim -t png -g "$geometry" "$shot" || fail "Screenshot capture failed."
        wl-copy --type image/png < "$shot" || fail "Could not copy screenshot."
        notify "Screenshot copied" "Selected area is ready to paste."
        ;;
    screenshot-full)
        directory="$HOME/Pictures/Screenshots"
        mkdir -p "$directory" || fail "Cannot create screenshot directory."
        shot=$(mktemp --suffix=.png "$directory/Screenshot-$(date +%Y-%m-%d_%H-%M-%S)-XXXXXX") ||
            fail "Cannot create screenshot file."
        if ! grim -t png "$shot"; then
            rm -f -- "$shot"
            fail "Screenshot capture failed."
        fi
        notify "Screenshot saved" "$shot"
        ;;
    clipboard-pick)
        command -v cliphist >/dev/null || fail "Install cliphist for clipboard history."
        entries=$(cliphist list) || fail "Cannot read clipboard history."
        [ -n "$entries" ] || { notify "Clipboard" "History is empty."; exit 0; }
        selection=$(printf '%s\n' "$entries" | wmenu -i -l 8 -p "Clipboard" \
            -f "Iosevka Nerd Font 11" -N E4E7EB -n 242A31 \
            -M E4E7EB -m 456B87 -S 456B87 -s F5F7FA) || exit 0
        [ -n "$selection" ] || exit 0
        # The selected line contains an opaque history ID; never evaluate it.
        clip=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/sway-clipboard.XXXXXX") ||
            fail "Cannot create clipboard buffer."
        trap 'rm -f -- "$clip"' 0
        trap 'exit 1' HUP INT TERM
        printf '%s\n' "$selection" | cliphist decode > "$clip" ||
            fail "Cannot decode clipboard entry."
        wl-copy < "$clip" || fail "Cannot restore clipboard."
        notify "Clipboard restored" "Ready to paste."
        ;;
    clipboard-clear)
        cliphist wipe || fail "Cannot clear clipboard history."
        wl-copy --clear || fail "History cleared; current clipboard could not be cleared."
        notify "Clipboard cleared" "History and current clipboard cleared."
        ;;
    media-toggle|media-next|media-previous)
        case "$1" in
            media-toggle) playerctl play-pause ;;
            media-next) playerctl next ;;
            media-previous) playerctl previous ;;
        esac || fail "No controllable media player found."
        status=$(playerctl status 2>/dev/null) || status="Command sent"
        notify "Media" "$status"
        ;;
    reload)
        sway -C -c "$HOME/.config/sway/config" >/dev/null 2>&1 ||
            fail "Config validation failed. Run sway -C -c ~/.config/sway/config."
        sway_command reload || fail "Sway could not reload its configuration."
        notify "Sway reloaded" "Configuration applied."
        ;;
    *)
        printf 'Unknown desktop action: %s\n' "$1" >&2
        exit 2
        ;;
esac

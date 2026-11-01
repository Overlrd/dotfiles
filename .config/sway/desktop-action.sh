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

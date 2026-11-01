#!/bin/sh
# Read-only checks. Run inside the Sway session; no packages/services are changed.
missing=0
for cmd in sway swaybg foot wmenu wmenu-run i3status pipewire wireplumber \
    pactl wpctl pavucontrol mako notify-send swayidle swaylock loginctl \
    dbus-update-activation-environment nmcli nmtui gammastep zsh hx tmux \
    zathura wl-copy wl-paste xdg-open xdg-mime git; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        printf 'MISSING command: %s\n' "$cmd"
        missing=$((missing + 1))
    fi
done
agent=/usr/libexec/polkit-gnome-authentication-agent-1
[ -x "$agent" ] || { printf 'MISSING Polkit agent: %s\n' "$agent"; missing=$((missing + 1)); }
if command -v xbps-query >/dev/null 2>&1; then
    if ! xbps-query -p pkgver zathura-pdf-mupdf >/dev/null 2>&1 &&
       ! xbps-query -p pkgver zathura-pdf-poppler >/dev/null 2>&1; then
        printf 'MISSING PDF backend: install zathura-pdf-mupdf OR zathura-pdf-poppler\n'
        missing=$((missing + 1))
    fi
    for pkg in xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr; do
        xbps-query -p pkgver "$pkg" >/dev/null 2>&1 ||
            { printf 'MISSING package: %s\n' "$pkg"; missing=$((missing + 1)); }
    done
fi
for term in foot tmux-256color; do
    infocmp "$term" >/dev/null 2>&1 ||
        { printf 'MISSING terminfo: %s\n' "$term"; missing=$((missing + 1)); }
done
for conf in 10-wireplumber.conf 20-pipewire-pulse.conf; do
    if [ ! -r "$HOME/.config/pipewire/pipewire.conf.d/$conf" ] &&
       [ ! -r "/etc/pipewire/pipewire.conf.d/$conf" ]; then
        printf 'CHECK PipeWire startup snippet (or equivalent custom setup): %s\n' "$conf"
    fi
done
[ -n "$WAYLAND_DISPLAY" ] || printf 'CHECK: run this inside Sway. WAYLAND_DISPLAY is unset.\n'
[ -n "$DBUS_SESSION_BUS_ADDRESS" ] || printf 'CHECK: D-Bus session variable is unset.\n'
[ -n "$XDG_RUNTIME_DIR" ] || printf 'CHECK: XDG_RUNTIME_DIR is unset.\n'
printf '\nMissing dependencies: %s\n' "$missing"
printf 'Editor: %s; visual editor: %s\n' "${EDITOR:-unset}" "${VISUAL:-unset}"
printf 'Next: hx --health (language servers/formatters are installed separately).\n'

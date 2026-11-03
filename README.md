# Dotfiles — minimal Void desktop

This branch uses Sway, Foot, wmenu, Swaybar/i3status, PipeWire and Mako.
Other desktop configurations and legacy scripts remain in the repository but
are not launched by this Sway config. The old screenshot is not a preview of
this branch.

## Packages

Install the explicit runtime dependencies (already-installed packages are skipped):

```sh
sudo xbps-install -S sway swaybg foot wmenu i3status mesa-dri dbus elogind \
  NetworkManager pipewire wireplumber pulseaudio-utils pavucontrol \
  swayidle swaylock mako libnotify polkit polkit-gnome \
  xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr \
  zsh helix tmux ncurses-term zathura zathura-pdf-mupdf gammastep \
  wl-clipboard xdg-utils git brightnessctl grim slurp \
  cliphist playerctl firefox Thunar
```

Iosevka Nerd Font is installed separately under ~/.local/share/fonts.
The D-Bus and NetworkManager services must be enabled; the normal user belongs
to the network group. Standalone dhcpcd/wpa_supplicant services must not compete
with NetworkManager.

## PipeWire setup

Run as your normal user, once. If a link already exists, inspect it instead of
overwriting it. These configuration snippets let PipeWire launch WirePlumber
and its PulseAudio-compatible server.

```sh
mkdir -p ~/.config/pipewire/pipewire.conf.d
ln -s /usr/share/examples/wireplumber/10-wireplumber.conf ~/.config/pipewire/pipewire.conf.d/
ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf ~/.config/pipewire/pipewire.conf.d/
```

Sway starts PipeWire directly. Do not also launch it through an autostart entry
or another session service. Sway also exports its Wayland environment to the
D-Bus activation environment and starts the Polkit GNOME authentication agent.
No dex or GTK settings command is launched. The NetworkManager terminal
interface uses the network group access.

## Applying this branch

Check `git status` before switching; preserve any local edits first.
Existing Stow symlinks continue to point to the same tracked files after a
branch switch. New bindings.conf and startup.conf files may need links: rerun your original Stow
command before validation if the directory is linked file by file.

Validate on the desktop before starting a new session:

```sh
sway -C -c ~/.config/sway/config
```

Log out and start a fresh session to replace the old startup processes.
A reload applies bindings and appearance but does not rerun ordinary exec lines.

```sh
dbus-run-session sway
```

After updating Void packages, the Intel GPU renderer starts normally. Do not
export `WLR_RENDERER=pixman`; that is only a software-rendering troubleshooting
fallback.

## Appearance: Ink

Dark bars, menus and notifications use near-white text. Bright blue marks focus,
green marks good status and Git, amber marks modes/brightness, red marks errors.
tmux shows the session in blue, a blue active window, green activity, and visible
PREFIX/ZOOM indicators. Helix uses brighter syntax accents and a dark status line.
Foot's colors section remains absent. Zathura and GTK retain their existing settings.
There is no Conky configuration tracked here; an installed/local Conky setup is
not replaced or automatically launched by this branch.

## Desktop controls

All bindings are in .config/sway/bindings.conf; startup programs are in
.config/sway/startup.conf. The main config holds settings, input and appearance.

Press **Super+Escape** to open Desktop mode. The bar shows the choices.
Release Super, then press a category key and an action key:

| Category | Actions |
| --- | --- |
| a — Apps | b browser, f files, n notes, t floating terminal, d launcher |
| s — System | n network, a audio mixer, r reload, d/e pointers off/on, m dismiss notification |
| c — Clipboard/capture | p history picker, x clear history, a area screenshot, f full screenshot |
| p — Power | l lock, s suspend, r reboot, p power off, e exit Sway |
| r — Resize | j/k/l/m or arrows; Return finishes |

Escape leaves any mode; BackSpace returns from submenus to Desktop.
Power actions execute immediately on their action key: save work before reboot,
poweroff or exit. Other actions return automatically to normal bindings.

Frequent controls stay direct: Super+Return terminal, Super+d launcher,
Super+r resize, Print area screenshot, Shift+Print full screenshot, media and
brightness keys. French AZERTY workspaces, j/k/l/m navigation and window/layout
controls are retained. Super+Ctrl+F9/F10 disable/restore internal pointers.
These direct bindings operate in default mode; press Escape to leave a menu first.
The former individual app, clipboard, reload and power shortcuts are replaced
by the menus above.

Automatic lock is after 5 minutes; displays switch off after 10 minutes.
Notes use ~/.notes and ${EDITOR:-hx}; NOTES_BACKUP=1 opts into the configured
Mega helper. No backup is enabled by default.

## Checks on the target machine

- Open the terminal, launcher, network menu and audio mixer.
- Check `wpctl status` and `pactl info`; the latter should show PipeWire.
- Test power-mode locking and unlocking before relying on automatic locking.
- Check the status bar's network/battery readings.

Reference: https://docs.voidlinux.org/config/media/pipewire.html

## Intermittent pointer fault

Both internal ALPS devices remain enabled at startup. If clicking gets stuck,
Mod + Ctrl + F9 disables only the internal stick and touchpad; external USB
mice are unaffected. With no external mouse, use the keyboard, then restore
internal input with Mod + Ctrl + F10. Recovery shortcuts are in the default
binding mode; leave any mode with Escape first. They also work while
locked. This is a workaround, not a diagnosis or guaranteed reset of a stuck
button. Capture libinput events during the fault to identify its source.

## Shortcut feedback

libnotify supplies notify-send; Mako displays its messages. Pointer recovery,
audio/microphone controls and config reload use .config/sway/desktop-action.sh.
Audio notifications show the resulting volume and mute state. Reload validates
the config first. Failed actions produce an error notification instead of a
success message. Volume/brightness notifications update in place using Mako stack tags and expire
after 1.5 seconds. Other success notices expire after two seconds; errors persist.
Notifications may not be visible
while the screen is locked. Window navigation and app launches stay quiet because
their results are already visible. The helper is invoked with sh, so it does not
need an executable bit. After pulling, check that the helper exists through your
Stow links; if .config/sway is linked file by file, re-run your original Stow command
to link the newly added helper before reloading.

## Shell, editor and multiplexer

.profile exports EDITOR=hx and VISUAL=hx for the desktop; .zprofile already
sources it. Set Zsh as your login shell after installing it:

```sh
chsh -s "$(command -v zsh)"
```

Log out fully and back in to refresh the desktop environment. Zsh uses built-in
completion and Git status, vi editing, and Ctrl+X Ctrl+E to edit a command in
Helix. Ctrl+S flow control is disabled on interactive terminals for tmux.
The t function attaches/creates main without forcibly detaching other clients.

Foot now advertises TERM=foot (the Void package depends on foot-terminfo);
the colors section is still absent. Remote SSH hosts may need Foot's terminfo
installed, or use TERM=xterm-256color for that SSH command as a fallback.

tmux retains Ctrl+S as prefix and h/j/k/l navigation. Press the prefix twice
to send Ctrl+S to an application. Copy-mode y uses wl-copy. Closing a pane
requires confirmation. RGB support is scoped to Foot; tmux-256color is used
when installed, with screen-256color as a fallback. ncurses-term supplies
the full terminfo collection. New Foot windows use the new TERM; existing
tmux clients should detach/reattach. Reload existing tmux config with
`tmux source-file ~/.tmux.conf`.

Helix uses a custom Ink theme with bright syntax colours, relative line
numbers, current-line highlighting and a buffer bar when multiple files are open.
Re-run your original Stow command if necessary to link the new themes directory.
Use `hx --health` to discover missing language servers and formatters; no
speculative language-server bundle is installed by these dotfiles.

## PDF reading

Zathura needs a document plugin: install zathura-pdf-mupdf (or the alternative
zathura-pdf-poppler, not both). Its interface matches Silver. PDF colours are
preserved by default; Ctrl+R toggles dark recolouring for reading. Set the PDF
association after installation:

```sh
xdg-mime default org.pwmt.zathura.desktop application/pdf
```

## Night colour

Sway starts:
`gammastep -m wayland -l 6.1319:1.2228 -t 6500:4000`

-l takes latitude:longitude, using approximate Lomé city coordinates.
-t sets daytime:nighttime temperatures in kelvin. Daylight remains neutral
at 6500 K; night becomes warm at 4000 K, with transitions based on the sun.
No location daemon is needed. The system clock must be correct.
This is an ordinary exec: reload does not start it; log in again, or run the
command once manually if Gammastep is not already running. Do not start a
second night-colour daemon alongside it.

## Remaining setup checks

- xdg-utils supplies file/URL association tools.
- Bluetooth support, battery/power tuning and a login greeter are optional follow-ups.
- Notes cloud backup stays disabled unless explicitly enabled.
- GPU acceleration was reported working; no software-rendering override is added.

## Backlight and screenshots

Install brightnessctl, grim and slurp; wl-clipboard supplies wl-copy.
The existing desktop-action.sh helper provides Mako feedback. Backlight controls
target intel_backlight explicitly, with a 5% floor (rounded up to device units)
and a 100% ceiling. They also work while locked.

Print starts an area selection; Escape cancels and preserves the clipboard.
Shift+Print captures all outputs without using the mouse and saves a uniquely
named PNG in ~/Pictures/Screenshots. Screenshot bindings are not enabled while
locked. Failed captures report an error rather than success.

If brightness writes are denied, check your video-group membership and the
brightnessctl udev rules; do not run Sway as root. On Void, adding your normal
user with `sudo usermod -aG video "$(id -un)"` and logging out/in may be needed.
The standalone Sway setup checker has been removed.

## Completing the local rollout

The repository configures the desktop; it cannot install packages or change
the laptop's services remotely. Install the listed dependencies, pull this
branch, then validate Sway and start a fresh session so the new clipboard
watcher starts once. No setup-check script is installed.

```sh
git pull --ff-only
sway -C -c ~/.config/sway/config && swaymsg reload
makoctl reload
```

Open a new Zsh shell (or source ~/.zshrc) for the blue-directory/green-Git prompt:
numeric exit status is no longer displayed. Restart GTK apps and Helix for the
theme change. Existing tmux servers need tmux source-file ~/.tmux.conf.

Clipboard history stores text and images locally until cleared; Desktop > Clipboard
opens the picker (p) or clears it (x). Escape cancels selection.
The watcher starts on login, not reload. To start it in the current session,
only if none is running: wl-paste --watch cliphist store.

Bluetooth, automatic mounts and a greeter are separate system-level choices,
not silently enabled. Check PDF and browser associations with xdg-mime/xdg-settings.
NetworkManager should be the sole network manager; a stale dhcpcd process or
resolv.conf ownership needs fixing on the machine, not in Sway.

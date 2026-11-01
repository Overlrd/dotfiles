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
  wl-clipboard xdg-utils git brightnessctl grim slurp
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
branch switch. There is no need to re-stow those files.

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

## Appearance: Graphite

A neutral black, white and grey desktop. Near-black #0E0E0E surfaces,
#202020 raised surfaces, #DEDEDE text and muted grey secondary text.
Windows use subtle 1px grey borders; unfocused borders blend into the
background. The bar has no bright workspace boxes: the active workspace
uses white text on dark grey. Urgent states use inverted white/black contrast.

Iosevka Nerd Font remains 11pt for Swaybar, launchers, Mako and GTK,
13pt for Foot and 20pt for Swaylock. Zero inner/outer gaps keep tiled windows
flush; square corners and quiet 1px notification borders keep the shell plain.
Both the application launcher and notes picker use light-grey selection rows.

Foot's colors section remains removed; its palette is the terminal default,
while its font and 6px padding are retained. Application content and GTK apps
can retain their own colours.

The GTK 3/4 `settings.ini` files request a dark Adwaita appearance and the
same font for compatible apps. They are new files: if your Stow setup links
individual files or directories, re-run your usual Stow command so the new
`gtk-3.0` and `gtk-4.0` paths become active. Apps may require a restart,
and applications with their own styling can ignore GTK preferences.

## Desktop controls

Mod is the Windows/Super key. Existing French AZERTY workspace bindings and
j/k/l/m navigation are retained.

| Shortcut | Action |
| --- | --- |
| Mod + Return | Terminal |
| Mod + Shift + Return | Floating terminal |
| Mod + d | Application launcher |
| Mod + n | Notes picker (wmenu + Foot) |
| Mod + Shift + n | NetworkManager menu |
| Mod + Shift + v | Audio mixer |
| Brightness keys | Adjust intel_backlight by 5%, minimum 5% |
| Print | Select area and copy PNG to clipboard |
| Shift + Print | Save all outputs to ~/Pictures/Screenshots |
| Mod + p (or Mod + Shift + p) | Power mode |
| Mod + r | Resize mode |
| Mod + Shift + c | Reload configuration |
| Mod + Shift + e | Power mode (e confirms session exit) |
| Mod + Ctrl + F9 | Disable both internal ALPS pointers |
| Mod + Ctrl + F10 | Re-enable both internal ALPS pointers |

In power mode: l locks, s locks then suspends, r reboots, p powers off.
Press e to exit Sway (save your work first). Escape or Return cancels. Automatic locking happens after 5 minutes;
displays switch off after 10 minutes. Keyboard/mouse activity turns them on.

Clipboard history, browser assignments and media-player keys remain unconfigured. The notes
picker is enabled: it creates `~/.notes` if necessary, opens Markdown notes in
Foot using `${EDITOR:-hx}`. Mega backup is opt-in: configure `rclone`, then
export `NOTES_BACKUP=1` to invoke the existing helper after editing.
The touchpad settings are retained: disabling tap does not disable the device.

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
binding mode; leave resize/power mode with Escape first. They also work while
locked. This is a workaround, not a diagnosis or guaranteed reset of a stuck
button. Capture libinput events during the fault to identify its source.

## Shortcut feedback

libnotify supplies notify-send; Mako displays its messages. Pointer recovery,
audio/microphone controls and config reload use .config/sway/desktop-action.sh.
Audio notifications show the resulting volume and mute state. Reload validates
the config first. Failed actions produce an error notification instead of a
success message. Notifications expire after two seconds; they may not be visible
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

Helix uses a custom Graphite theme with subdued syntax colours, relative line
numbers, current-line highlighting and a buffer bar when multiple files are open.
Re-run your original Stow command if necessary to link the new themes directory.
Use `hx --health` to discover missing language servers and formatters; no
speculative language-server bundle is installed by these dotfiles.

## PDF reading

Zathura needs a document plugin: install zathura-pdf-mupdf (or the alternative
zathura-pdf-poppler, not both). Its interface matches Graphite. PDF colours are
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

- Clipboard history remains unconfigured.
- Firefox is installed separately. xdg-utils supplies file/URL association tools.
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

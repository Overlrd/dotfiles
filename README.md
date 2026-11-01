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
  xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr
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

## Appearance: Deep Pine

The compact desktop uses Iosevka Nerd Font throughout: 11pt for Swaybar,
wmenu, Mako and GTK; 13pt for Foot; 20pt for Swaylock. All UI uses square
corners and restrained spacing. Core colors are deep pine `#151E1B`, forest
`#2D4038`, sage `#95B8A2` and pale mist `#DDE7DE`; muted red marks
errors and soft amber marks warnings. Foot uses a complementary ANSI palette
and a 6px inner margin.

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
| Mod + p (or Mod + Shift + p) | Power mode |
| Mod + r | Resize mode |
| Mod + Shift + c | Reload configuration |
| Mod + Shift + e | Power mode (e confirms session exit) |
| Mod + Ctrl + F9 | Disable both internal ALPS pointers |
| Mod + Ctrl + F10 | Re-enable both internal ALPS pointers |

In power mode: l locks, s locks then suspends, r reboots, p powers off.
Press e to exit Sway (save your work first). Escape or Return cancels. Automatic locking happens after 5 minutes;
displays switch off after 10 minutes. Keyboard/mouse activity turns them on.

Screenshots, clipboard history, browser assignments, media-player keys and
brightness keys are omitted until their applications are installed. The notes
picker is enabled: it creates `~/.notes` if necessary, opens Markdown notes in
Foot using `${EDITOR:-nvim}` (install `neovim` or set `EDITOR`), then runs the
existing Mega backup helper if executable. Configure `rclone` for that backup
or remove the helper locally if you do not want automatic uploads.
The touchpad settings are retained: disabling tap does not disable the device.

## Checks on the target machine

- Open the terminal, launcher, network menu and audio mixer.
- Check `wpctl status` and `pactl info`; the latter should show PipeWire.
- Test power-mode locking and unlocking before relying on automatic locking.
- Check the status bar's network/battery readings.
- Revisit the renderer error with the Sway debug log.

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

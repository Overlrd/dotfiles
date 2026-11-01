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
  swayidle swaylock mako
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
or another session service. No dex, GTK settings command or Polkit agent is
launched. The NetworkManager terminal interface uses the network group access.

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

The Dell currently needs this temporary CPU-rendering fallback:

```sh
WLR_RENDERER=pixman dbus-run-session sway
```

GPU acceleration remains unresolved. The fallback is deliberately not exported
globally or embedded in the dotfiles.

## Desktop controls

Mod is the Windows/Super key. Existing French AZERTY workspace bindings and
j/k/l/m navigation are retained.

| Shortcut | Action |
| --- | --- |
| Mod + Return | Terminal |
| Mod + Shift + Return | Floating terminal |
| Mod + d | Application launcher |
| Mod + Shift + n | NetworkManager menu |
| Mod + Shift + v | Audio mixer |
| Mod + p (or Mod + Shift + p) | Power mode |
| Mod + r | Resize mode |
| Mod + Shift + c | Reload configuration |
| Mod + Shift + e | Exit confirmation |

In power mode: l locks, s locks then suspends, r reboots, p powers off.
Escape or Return cancels. Automatic locking happens after 5 minutes;
displays switch off after 10 minutes. Keyboard/mouse activity turns them on.

Screenshots, clipboard history, note scripts, browser assignments, media-player
keys and brightness keys are omitted until their applications are installed.
The touchpad settings are retained: disabling tap does not disable the device.

## Checks on the target machine

- Open the terminal, launcher, network menu and audio mixer.
- Check `wpctl status` and `pactl info`; the latter should show PipeWire.
- Test power-mode locking and unlocking before relying on automatic locking.
- Check the status bar's network/battery readings.
- Revisit the renderer error with the Sway debug log.

Reference: https://docs.voidlinux.org/config/media/pipewire.html

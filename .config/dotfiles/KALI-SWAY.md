# Kali Wayland, Sway, and SwayFX Setup

This guide covers migrating these dotfiles to Kali, installing Kali with only
Wayland and Sway, and using SwayFX even though Kali does not currently package it.

## Dotfiles migration

The dotfiles and migration tooling are published at
[lantzops/dotFiles](https://github.com/lantzops/dotFiles).

The repository includes:

- 41 wallpapers (approximately 166 MB)
- Sway, Waybar, SwayNC, SwayOSD, Fuzzel, terminal, shell, and editor configs
- Bundled JetBrains Mono Nerd Font and SF Pro fonts
- A Kali package bootstrap
- Automatic backup of conflicting files
- Portable `$HOME` paths
- Linux/macOS-compatible Git aliases
- `swww` wallpaper support with a `swaybg` fallback
- Exclusions for credentials, machine state, caches, and generated files

On the Kali machine, run:

```bash
bash <(curl -fsSL \
  https://raw.githubusercontent.com/lantzops/dotFiles/main/bootstrap-kali.sh)
```

After installation, log out, select the Sway session, and log back in. Monitor
layouts are hardware-specific, so review:

```text
~/.config/sway/config.d/outputs.conf
```

## Minimal Kali with Wayland and Sway only

Kali can run without Plasma, GNOME, or Xfce. The cleanest approach is to begin
with a headless/minimal Kali installation and add Sway afterward. The regular
Kali Installer image permits installing without a desktop environment; the Live
image does not offer the same package-selection flow.

During installation:

1. Use the regular **Installer** image, not the Live image.
2. At **Software selection**, uncheck every desktop environment.
3. Select only the Kali tool collection needed, such as `kali-linux-core`, Top
   10, or Default.
4. Complete installation and boot into the text console.

Kali documents both its
[installer process](https://www.kali.org/docs/installation/hard-disk-install/)
and the option to create a
[headless installation](https://www.kali.org/docs/introduction/what-image-to-download/).

Install the base Sway environment:

```bash
sudo apt update
sudo apt full-upgrade -y

sudo apt install -y \
  sway swaybg swayidle swaylock \
  waybar fuzzel foot \
  sway-notification-center swayosd \
  grim slurp wl-clipboard cliphist \
  brightnessctl playerctl \
  pipewire pipewire-audio wireplumber \
  network-manager network-manager-gnome \
  xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
  dbus-user-session policykit-1
```

If those packages were installed manually, download the dotfiles bootstrap and
skip its package step:

```bash
curl -fsSLO \
  https://raw.githubusercontent.com/lantzops/dotFiles/main/bootstrap-kali.sh
chmod +x bootstrap-kali.sh
./bootstrap-kali.sh --skip-packages
```

Start Sway directly from a TTY:

```bash
sway
```

To start Sway automatically after logging into TTY1, add this to
`~/.bash_profile`:

```bash
if [[ -z "${WAYLAND_DISPLAY:-}" && "${XDG_VTNR:-0}" -eq 1 ]]; then
    exec sway
fi
```

For a strictly Wayland-only session, add this near the top of the Sway config:

```text
xwayland disable
```

Disabling XWayland prevents legacy X11 applications from running. Some older or
Electron-based applications may therefore stop working.

If removing an existing Kali desktop from an already-installed system, take
extra care: Kali marks `kali-desktop-*` packages as system-protected. Follow
Kali's current
[desktop switching documentation](https://www.kali.org/docs/general-use/switching-desktop-environments/)
instead of removing packages blindly. A fresh minimal installation is safer.

## Using SwayFX on Kali

SwayFX can run on Kali. The limitation is packaging: Kali currently provides
vanilla Sway, but not a `swayfx` package in its official repository. Consequently,
`apt install swayfx` is not presently an option.

The practical choices are:

1. Build SwayFX from source. This is the recommended route.
2. Install an unofficial third-party package. This is easier, but introduces a
   trust and upgrade-maintenance risk.
3. Use vanilla Sway. This is easiest to maintain but does not provide SwayFX
   blur, shadows, or rounded corners.

For Kali, install a pinned SwayFX release under `/usr/local`. This keeps the
locally built version separate from packages managed by `apt`. Keep Kali's
regular Sway package installed as a fallback:

```bash
sudo apt install sway
```

If SwayFX installs `/usr/local/bin/sway`, it will normally take precedence over
Kali's `/usr/bin/sway`. Confirm which compositor will start with:

```bash
command -v sway
sway --version
```

The expected result after a successful SwayFX installation is similar to:

```text
/usr/local/bin/sway
swayfx ...
```

The important compatibility chain is:

```text
SwayFX -> SceneFX -> wlroots -> Wayland libraries
```

These projects evolve quickly, so pin compatible releases rather than building
arbitrary development branches. A Kali upgrade may occasionally require rebuilding
SwayFX. Upstream Sway documents the common
[Meson and Ninja build process](https://github.com/swaywm/sway), while SwayFX's
source and release history live in the
[SwayFX repository](https://github.com/WillPower3309/swayfx).

These dotfiles already contain SwayFX appearance directives, including:

```text
corner_radius
blur
blur_xray
blur_passes
shadows
layer_effects
```

Once SwayFX is installed, those appearance settings can be used. Vanilla Sway
may report them as unsupported while the remaining Waybar, SwayNC, Fuzzel,
wallpaper, keybinding, and shell configuration stays applicable.

### Planned bootstrap enhancement

The current `bootstrap-kali.sh` installs the official Kali Sway package. A useful
future enhancement would add a separate mode such as:

```bash
./bootstrap-kali.sh --swayfx
```

That mode should install build dependencies, check out pinned compatible SwayFX
and SceneFX releases, install them under `/usr/local`, and retain `/usr/bin/sway`
as a fallback. The `--swayfx` option is a proposal and is **not implemented yet**.

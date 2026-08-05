#!/usr/bin/env bash
# Bootstrap this dotfiles collection on Kali Linux.
set -Eeuo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/lantzops/dotFiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BACKUP_DIR="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)}"
SKIP_PACKAGES=0

for arg in "$@"; do
    case "$arg" in
        --skip-packages) SKIP_PACKAGES=1 ;;
        -h|--help)
            echo "Usage: $0 [--skip-packages]"
            echo "Environment: DOTFILES_REPO, DOTFILES_DIR, DOTFILES_BACKUP_DIR"
            exit 0 ;;
        *) echo "Unknown option: $arg" >&2; exit 2 ;;
    esac
done

if [[ $EUID -eq 0 ]]; then
    echo "Run this as your normal user; the script invokes sudo when needed." >&2
    exit 1
fi
if ! grep -qi kali /etc/os-release; then
    echo "Warning: this installer is designed for Kali Linux." >&2
fi

install_packages() {
    local wanted=()
    local candidates=(
        git curl sway swaybg swayidle swaylock waybar fuzzel foot alacritty
        sway-notification-center swayosd sway-contrib grim slurp wl-clipboard
        cliphist brightnessctl playerctl pavucontrol pipewire pipewire-audio
        wireplumber network-manager-gnome blueman jq python3 python3-requests
        libnotify-bin xdg-desktop-portal-wlr xdg-desktop-portal-gtk
        fonts-jetbrains-mono fonts-font-awesome papirus-icon-theme
        firefox-esr nemo vim zsh fish htop btop mpv
    )

    sudo apt-get update
    for package in "${candidates[@]}"; do
        if apt-cache show "$package" >/dev/null 2>&1; then
            wanted+=("$package")
        else
            printf 'Skipping unavailable package: %s\n' "$package"
        fi
    done
    sudo apt-get install -y "${wanted[@]}"
}

checkout_dotfiles() {
    command -v git >/dev/null || { echo "git is required" >&2; exit 1; }
    mkdir -p "$HOME"
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        git clone --bare "$REPO_URL" "$DOTFILES_DIR"
    fi
    git --git-dir="$DOTFILES_DIR" config status.showUntrackedFiles no

    local conflicts
    conflicts="$(git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout 2>&1 || true)"
    if grep -q 'would be overwritten by checkout' <<<"$conflicts"; then
        mkdir -p "$BACKUP_DIR"
        while IFS= read -r path; do
            [[ -n "$path" && -e "$HOME/$path" ]] || continue
            mkdir -p "$BACKUP_DIR/$(dirname "$path")"
            mv "$HOME/$path" "$BACKUP_DIR/$path"
        done < <(sed -n '/would be overwritten by checkout:/,/Please commit/p{s/^[[:space:]]*//;/^\./p}' <<<"$conflicts")
        git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout
        echo "Existing files were backed up to $BACKUP_DIR"
    elif [[ -n "$conflicts" ]]; then
        echo "$conflicts" >&2
        git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout
    fi
}

install_fonts() {
    local source="$HOME/.config/hypr/Fonts"
    [[ -d "$source" ]] || return 0
    mkdir -p "$HOME/.local/share/fonts/dotfiles"
    find "$source" -type f \( -iname '*.ttf' -o -iname '*.otf' \) \
        -exec cp -n {} "$HOME/.local/share/fonts/dotfiles/" \;
    command -v fc-cache >/dev/null && fc-cache -f "$HOME/.local/share/fonts"
}

if (( ! SKIP_PACKAGES )); then
    install_packages
fi
checkout_dotfiles
install_fonts
find "$HOME/.config/sway/scripts" "$HOME/.config/waybar/scripts" \
    -type f -name '*.sh' -exec chmod u+x {} + 2>/dev/null || true

echo
echo "Kali dotfiles setup complete."
echo "Log out, select the Sway session, and log back in."
echo "Hardware-specific monitor settings live in ~/.config/sway/config.d/outputs.conf."
echo "SwayFX-only effects are preserved; vanilla Sway may report them as unsupported."

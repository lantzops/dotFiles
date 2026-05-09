#!/usr/bin/env bash
# Bootstrap dotfiles + tools on a fresh macOS install.
#
# Run with:
#   bash <(curl -fsSL https://raw.githubusercontent.com/lantzops/dotFiles/main/bootstrap-mac.sh)
#
# Prereqs: an SSH key authorized for git@github.com:lantzops/dotFiles.git.
# Generate one first with `ssh-keygen -t ed25519` and add the pubkey to
# https://github.com/settings/keys.

set -euo pipefail

REPO=git@github.com:lantzops/dotFiles.git
DOT="$HOME/.dotfiles"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

[[ "$(uname)" == "Darwin" ]] || die "this script is for macOS only"

# --- 1. Homebrew ---
if ! command -v brew >/dev/null 2>&1; then
    log "installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to PATH for this script
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    log "Homebrew already installed"
fi

# --- 2. Clone dotfiles bare repo ---
if [[ -d "$DOT" ]]; then
    log "$DOT already exists — skipping clone"
else
    log "cloning dotfiles to $DOT"
    git clone --bare "$REPO" "$DOT"
fi

GIT="git --git-dir=$DOT --work-tree=$HOME"
$GIT config --local status.showUntrackedFiles no
$GIT config --local core.sparseCheckout true

# --- 3. Sparse-checkout: exclude Linux/wayland-only paths ---
log "configuring sparse-checkout (excluding wayland-only configs)"
mkdir -p "$DOT/info"
cat > "$DOT/info/sparse-checkout" <<'EOF'
/*
!/.config/sway/
!/.config/swaync/
!/.config/swayosd/
!/.config/swayr/
!/.config/waybar/
!/.config/waypaper/
!/.config/fuzzel/
!/.config/hypr/
!/.gtkrc-2.0
!/arch-setup-script.sh
EOF

# --- 4. Back up any conflicting files in $HOME ---
BACKUP="$HOME/.dotfiles-backup"
log "checking for conflicts; conflicts go to $BACKUP/"
mapfile -t conflicts < <($GIT checkout 2>&1 | awk '/would be overwritten|already exists/{flag=1; next} flag && NF{print $1}' | tr -d '\t' || true)
if (( ${#conflicts[@]} > 0 )); then
    mkdir -p "$BACKUP"
    for f in "${conflicts[@]}"; do
        [[ -e "$HOME/$f" ]] || continue
        mkdir -p "$BACKUP/$(dirname "$f")"
        mv "$HOME/$f" "$BACKUP/$f"
    done
fi

# --- 5. Check out working tree ---
log "checking out dotfiles"
$GIT checkout

# --- 6. Install brew packages from Brewfile ---
if [[ -f "$HOME/Brewfile" ]]; then
    log "running brew bundle install"
    brew bundle install --file="$HOME/Brewfile"
fi

# --- 7. Make brew bash the default login shell ---
BREW_BASH="$(brew --prefix)/bin/bash"
if [[ -x "$BREW_BASH" ]]; then
    if ! grep -qxF "$BREW_BASH" /etc/shells; then
        log "adding $BREW_BASH to /etc/shells (requires sudo)"
        echo "$BREW_BASH" | sudo tee -a /etc/shells >/dev/null
    fi
    if [[ "$SHELL" != "$BREW_BASH" ]]; then
        log "changing default shell to $BREW_BASH"
        chsh -s "$BREW_BASH"
    fi
fi

# --- 8. Add 'config' alias note ---
log "done"
echo
echo "The 'config' alias is already in .bashrc. To use it now:"
echo "  source ~/.bashrc && config status"
echo
echo "Conflicts (if any) backed up to: $BACKUP"

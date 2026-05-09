# Brewfile — Mac install list, derived from Arch/CachyOS package set
# Use: brew bundle install --file=~/Brewfile

# --- Shells & prompt ---
brew "bash"                # macOS ships bash 3.2; install latest
brew "bash-completion@2"
brew "fish"
brew "oh-my-posh"

# --- Core CLI ---
brew "git"
brew "openssh"
brew "tmux"
brew "vim"
brew "neovim"
brew "wget"
brew "rsync"               # macOS builtin is ancient
brew "less"                # newer than macOS builtin
brew "coreutils"           # GNU coreutils as g-prefixed; bridges Linux muscle memory
brew "gnu-sed"
brew "gawk"
brew "findutils"

# --- Search / nav / file mgmt ---
brew "ripgrep"
brew "fd"
brew "fzf"
brew "zoxide"
brew "bat"
brew "eza"
brew "yazi"
brew "tree"
brew "duf"

# --- TUI tools ---
brew "btop"
brew "htop"
brew "glances"
brew "micro"
brew "fastfetch"
brew "figlet"
brew "lolcat"
brew "cmatrix"

# --- Dev / infra ---
brew "node"                # nodejs + npm
brew "python"
brew "pipx"
brew "tree-sitter"
brew "opentofu"
brew "terraform"           # if you actually need both, pick one
brew "chezmoi"
brew "tailscale"
brew "smartmontools"

# --- Media ---
brew "mpv"
brew "ffmpeg"
brew "ffmpegthumbnailer"

# === GUI apps (casks) ===

# --- Terminals ---
cask "alacritty"
cask "ghostty"
cask "wezterm"

# --- Browsers ---
cask "firefox"

# --- Apps ---
cask "obsidian"
cask "anki"
cask "discord"
cask "vlc"
cask "meld"

# --- VM / virtualization (uncomment one) ---
# cask "utm"               # free, QEMU-based, great for Linux guests
# cask "vmware-fusion"     # free for personal use; better perf
# cask "parallels"         # paid; smoothest experience

# --- Mac-specific quality-of-life (not on Linux) ---
# cask "raycast"           # spotlight replacement
# cask "rectangle"         # window snapping
# cask "stats"             # menubar system monitor

# --- Fonts ---
brew "font-jetbrains-mono-nerd-font"
brew "font-meslo-lg-nerd-font"
brew "font-monaspace-nerd-font"

# Notes:
# - Linux-only and not migrated: swayfx, swaync, swayosd, waybar, fuzzel,
#   waypaper, hyprlock, mako, nemo, blueman, networkmanager, ufw, lvm2, mdadm,
#   nvidia-*, mesa-*, alsa-*, pipewire-*, plymouth, mkinitcpio, etc.
# - macOS replacements: pf (firewall), launchd (systemd), Time Machine (backup),
#   Disk Utility (gparted-ish), Spotlight (locate/plocate).

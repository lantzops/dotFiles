#!/bin/bash

# Arch Linux Setup Script with CachyOS Repository
# 1. Adds CachyOS Repos
# 2. Reinstalls all native packages (to apply CachyOS optimizations)
# 3. Installs AUR helpers (yay/paru) from CachyOS repo
# 4. Installs user-defined packages

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Helper Functions ---

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

ask_confirmation() {
    local prompt="$1"
    local default="${2:-n}"
    local response
    echo -n -e "${YELLOW}${prompt} (Y/n): ${NC}"
    read -r response
    [[ -z "$response" ]] && response=$default
    [[ $response =~ ^[Yy]$ ]]
}

if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root (it invokes sudo where needed)."
   exit 1
fi

# --- CachyOS Repository Functions ---

check_cachyos_repo() {
    if grep -q "^\\[cachyos\\]" /etc/pacman.conf; then
        return 0
    else
        return 1
    fi
}

add_cachyos_repo() {
    print_status "Adding CachyOS repository..."
    
    # Backup pacman.conf
    sudo cp /etc/pacman.conf "/etc/pacman.conf.backup.$(date +%Y%m%d_%H%M%S)"

    # Download installer
    if command -v curl >/dev/null 2>&1; then
        curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
    elif command -v wget >/dev/null 2>&1; then
        wget https://mirror.cachyos.org/cachyos-repo.tar.xz
    else
        print_error "Neither curl nor wget found."
        exit 1
    fi

    tar xvf cachyos-repo.tar.xz
    cd cachyos-repo
    chmod +x ./cachyos-repo.sh
    sudo ./cachyos-repo.sh
    cd ..
    rm -rf cachyos-repo cachyos-repo.tar.xz

    print_success "CachyOS repository added."
}

# --- Core Logic Functions ---

reinstall_optimized_packages() {
    print_status "Reinstalling all native packages to use CachyOS optimized versions..."
    print_warning "This might take a while depending on your internet speed."
    
    # Get list of native packages (excluding AUR/foreign)
    # We pipe this into pacman to reinstall them
    if pacman -Qqn | sudo pacman -S - --noconfirm --needed; then
        print_success "All native packages reinstalled/optimized."
    else
        print_error "Failed to reinstall packages."
        exit 1
    fi
}

install_aur_helpers_from_repo() {
    print_status "Installing yay and paru from CachyOS repository..."
    # Since CachyOS repo is now added, we can just use pacman
    sudo pacman -S --needed --noconfirm yay paru
    print_success "yay and paru installed."
}

handle_sway_conflict() {
    # CRITICAL FIX: You cannot install swayfx if sway is installed.
    # Since you are on a fresh sway install, 'sway' is likely present.
    # We must remove 'sway' to allow 'swayfx' to install.
    
    if pacman -Qi sway > /dev/null 2>&1; then
        print_warning "Detected 'sway' installed. Removing it to allow 'swayfx' installation..."
        # -Rdd skips dependency checks (safe here because we immediately install swayfx which provides sway)
        sudo pacman -Rdd sway --noconfirm
        print_success "Standard sway removed (will be replaced by swayfx)."
    fi
}

# --- Package List ---

PACKAGES=(
    # Essential
    "base-devel"
    "git"
    
    # Window Manager (SwayFX)
    "swayfx" 
    "swayidle" "swaybg" "waybar" "waypaper" "wl-clipboard" "cliphist" 
    "autotiling-rs" "swaync" "swayosd" "swayimg" "sway-contrib" 
    "grim" "slurp" "wofi"

    # Terminal
    "wezterm" "fuzzel" "bat" "alacritty" "foot" "eza" "zsh" "oh-my-posh"

    # Apps
    "brave-bin" "nemo" "nemo-fileroller" "nemo-python" "nemo-terminal" 
    "nemo-preview" "nemo-seahorse" "nemo-emblems" "nemo-image-converter" 
    "nemo-pastebin" "nemo-audio-tab" "firefox" "firefox-ublock-origin" 
    "visual-studio-code-bin" "zed" "yazi"

    # Audio/Pipewire
    "pipewire" "pipewire-alsa" "pipewire-pulse" "pipewire-jack" 
    "wireplumber" "gst-plugin-pipewire" "pavucontrol" "pasystray"

    # Utilities
    "swww" "brightnessctl" "networkmanager" "networkmanager-dmenu" 
    "network-manager-applet" "blueman" "bluez" "bluez-utils" "iwd" 
    "wireless_tools" "xdg-utils" "htop" "neofetch" "bleachbit" "timeshift" 
    "reflector" "dosfstools" "mtools" "btrfs-progs" "lvm2" "smartmontools" 
    "snapper" "zram-generator"

    # Theming/Fonts
    "adwaita-icon-theme" "adwaita-cursors" "adwaita-fonts" "otf-font-awesome" 
    "ttf-0xproto-nerd" "ttf-jetbrains-mono-nerd" "ttf-meslo-nerd" 
    "ttf-dejavu" "ttf-liberation" "noto-fonts" 
    "lxappearance" "papirus-icon-theme" "breeze-gtk-theme" "materia-gtk-theme" 
    "qt5ct" "kvantum"

    # Dev Tools
    "rustup" "rust-analyzer" "go" "python" "nodejs" "npm" "github-cli"

    # Graphics/Drivers
    "mesa" "vulkan-radeon" "vulkan-intel" "vulkan-nouveau" 
    "libva-mesa-driver" "libva-intel-driver" "intel-media-driver" 
    "intel-media-sdk" "xf86-video-amdgpu" "xf86-video-ati" 
    "xf86-video-nouveau" "v4l2loopback-dkms"

    # Gaming
    "gamemode" "gamescope" "steam" "wine" "protonup-qt"

    # Comms
    "discord" "telegram-desktop" "ayugram-desktop" "vesktop"

    # Archive tools
    "zip" "unzip" "p7zip" "tar" "file-roller" "peazip"

    # Editors
    "nvim" "nano" "gedit" "vim"

    # Others
    "octopi" "hyprlock" "wmenu" "obs-studio-browser" "gimp" "krita" "libreoffice-still"
)

install_user_packages() {
    print_status "Installing user packages list..."
    
    # Set Package Manager (We know yay is installed now)
    PACKAGE_MANAGER="yay"
    
    # Flatten array to string
    PKG_LIST="${PACKAGES[*]}"
    
    # Install
    $PACKAGE_MANAGER -S --needed --noconfirm $PKG_LIST
    
    print_success "All packages installed successfully!"
}

# --- Main Execution ---

main() {
    print_status "Starting Optimized Arch Setup..."

    # 1. Handle CachyOS Repo
    if ! check_cachyos_repo; then
        if ask_confirmation "Add CachyOS repository?"; then
            add_cachyos_repo
            sudo pacman -Sy # Refresh immediately
        fi
    else
        print_success "CachyOS repo already present."
    fi

    # 2. Reinstall Native Packages (Optimize)
    if ask_confirmation "Reinstall ALL native packages (Apply CachyOS optimizations)?"; then
        reinstall_optimized_packages
    fi

    # 3. Install Helpers from Repo
    install_aur_helpers_from_repo

    # 4. Install User Packages
    if ask_confirmation "Proceed with installing your package list?"; then
        # Handle the sway vs swayfx conflict before starting
        handle_sway_conflict
        install_user_packages
    fi

    print_success "Setup Completed."
    echo -e "\n${GREEN}Note:${NC} Reboot is recommended to ensure all optimized binaries and drivers are loaded."
}

main "$@"

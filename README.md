# dotfiles

My personal dotfiles for an Arch/CachyOS setup running sway (swayfx) on Wayland.

Tracked with the [bare-repo-in-$HOME](https://www.atlassian.com/git/tutorials/dotfiles) approach — no symlinks, files live where they belong, and the repo metadata stays out of the way at `~/.dotfiles/`.

## What's in here

- **Shells:** `.bashrc`, `.bash_profile`, `.zshrc`, fish config (`.config/fish/`)
- **Editors:** `.vimrc`, `.vim/coc-settings.json`, micro
- **Wayland / sway:** sway config + scripts, waybar, swaync, swayosd, swayr, fuzzel, hyprlock, waypaper
- **Terminals:** alacritty, ghostty, wezterm
- **TUI tools:** btop, htop, yazi, mpv
- **Setup:** `arch-setup-script.sh` — bootstrap script for fresh CachyOS installs

## Install

### macOS (one-liner)

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/lantzops/dotFiles/main/bootstrap-mac.sh)
```

This installs Homebrew, clones the repo with sparse-checkout (excludes Linux/wayland-only configs), runs `brew bundle install` from the [Brewfile](Brewfile), and switches your login shell to brew bash. Prereq: an SSH key authorized for this repo.

### Linux (manual)

```sh
# 1. Clone as a bare repo
git clone --bare git@github.com:lantzops/dotFiles.git $HOME/.dotfiles

# 2. Define a convenience alias for this shell
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# 3. Hide untracked files (your home dir is the work tree)
config config --local status.showUntrackedFiles no

# 4. Check out the working tree
config checkout

# 5. Add the alias permanently to your shell rc
echo "alias config='git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/.bashrc
```

If step 4 fails because a file already exists, back up the conflicts and retry:

```sh
mkdir -p ~/.dotfiles-backup
config checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | \
  xargs -I{} sh -c 'mkdir -p ~/.dotfiles-backup/$(dirname {}) && mv {} ~/.dotfiles-backup/{}'
config checkout
```

## Daily use

```sh
config status              # what's changed
config add .config/sway/config
config commit -m "sway: rebind workspace switcher"
config push
```

## License

[Apache 2.0](LICENSE)

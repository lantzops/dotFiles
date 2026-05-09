#
# ~/.zshrc - Merged Configuration (CachyOS + Current Config)
#

# ===============================================
# 1. STARTUP
# ===============================================
# Only run colorscript if it's available
if command -v colorscript >/dev/null 2>&1; then
    colorscript -e 30
fi

# ===============================================
# 2. ZINIT INSTALLATION AND INITIALIZATION
# ===============================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "${ZINIT_HOME}" ]; then
    print -P "%F{33}Installing Zinit...%f"
    mkdir -p "$(dirname ${ZINIT_HOME})"
    git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi

source "${ZINIT_HOME}/zinit.zsh"

# ===============================================
# 3. ZSH OPTIONS
# ===============================================
setopt HIST_IGNORE_DUPS
setopt AUTO_CD
setopt PROMPT_SUBST
setopt GLOB_DOTS
setopt CORRECT
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ===============================================
# 4. ZINIT PLUGIN LOADS (Combining both configs, avoiding duplicates)
# ===============================================

# Core Plugins (from new config - replacing conflicting ones)
zinit light zdharma-continuum/fast-syntax-highlighting  # Instead of zsh-syntax-highlighting
zinit light marlonrichert/zsh-autocomplete              # Instead of zsh-autosuggestions

# Core Plugins (from original config)
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

# New plugins from the CachyOS config
zinit light zsh-users/zsh-history-substring-search
zinit light ajeetdsouza/zoxide

# Oh My Zsh plugins
zinit snippet OMZP::git
zinit snippet OMZP::sudo

# ===============================================
# 5. HISTORY SETTINGS
# ===============================================
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# ===============================================
# 6. POST-PLUGIN CONFIGURATION
# ===============================================

# Zoxide Initialization
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# History Substring Search Key Bindings (new config)
bindkey -M emacs '^[[A' history-substring-search-up
bindkey -M emacs '^[[B' history-substring-search-down
bindkey -M vicmd '^[[A' history-substring-search-up
bindkey -M vicmd '^[[B' history-substring-search-down

# Additional keybinding from original config
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -e

# ===============================================
# 7. OH MY POSH SETUP
# ===============================================
if ! which oh-my-posh >/dev/null 2>&1; then
  curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# Try the new theme path, fallback to original if not available
if [ -f "/usr/share/oh-my-posh/themes/catppuccin.omp.json" ]; then
    OH_MY_POSH_THEME="/usr/share/oh-my-posh/themes/catppuccin.omp.json"
elif [ -f "$HOME/.config/omp/config.toml" ]; then
    OH_MY_POSH_THEME="$HOME/.config/omp/config.toml"
fi

if command -v oh-my-posh >/dev/null 2>&1; then
    eval "$(oh-my-posh init zsh --config ${OH_MY_POSH_THEME})"
else
    PROMPT='%n@%m %~ %# '
fi

# ===============================================
# 8. COMPLETION SETUP
# ===============================================
autoload -Uz compinit && compinit
zinit cdreplay -q

# Initialize Homebrew if it's installed
if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
fi

# ===============================================
# 9. FUNCTIONS
# ===============================================
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    trash -- "$tmp"
}

# ===============================================
# 10. ALIASES
# ===============================================

#-----#
# Eza #
#-----#
alias lal='eza -lh  --icons=auto --sort=name --group-directories-first' # long list
alias ls='eza -1   --icons=auto --sort=name --group-directories-first' # short list
alias tree='eza --icons=auto --sort=name --tree' # list folder as tree

#---------#
# Removed #
#---------#
alias rm='echo "\033[34mUse \033[32mts\033[34m for file removal instead.\nIf you want to use \033[32mrm\033[34m type \033[32m\\\rm\033[34m to use it.\033[0m"; false'
alias wget='echo "\033[34mUse \033[32mxh\033[34m instead.\nIf you want to use \033[32mwget\033[34m type \033[32m\\wget\033[34m to use it.\033[0m"; false'

#-------#
# Trash #
#-------#
alias ts="trash" # Safer version of rm. Places deleted file in ~/.local/share/Trash/
alias tsrm="trash-rm" # Remove one item from ~/.local/share/Trash/
alias tsls="trash-list" # List items in ~/.local/share/Trash/
alias empty="trash-empty" # Empty the contents of ~/.local/share/Trash/
alias restore="trash-restore" # Restore one item from ~/.local/share/Trash/

#----------------#
# Quick Commands #
#----------------#
alias p="mocp"
alias bonsai="cbonsai"
alias g="lazygit"
alias present="presenterm"
alias df="duf"
alias mkdir='mkdir -p'
# alias z='cd'
alias v='vim'
alias c='clear'
alias reload='source ~/.zshrc'
alias rice="xh -b -F GET git.io/rice"
alias matrix="neo-matrix -D -c purple"

#------------#
# Navigation #
#------------#
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

#----------#
# Modified #
#----------#
alias clock="tty-clock -cD -C 4"
alias icat='c; kitten icat'
alias bash="c; bash"
alias zigup="zigup --path-link $HOME/.local/bin/zig"
alias parui="parui -p=yay"
alias speedtest="speedtest --simple --secure"


#-----------#
# Variables #
#-----------#
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export BAT_THEME="Catppuccin Mocha"
export TERMINAL="/usr/bin/kitty"
export EDITOR="vim"
export VISUAL="vim"
export PATH="$HOME/Desktop/.Scripts/:$HOME/.local/bin/:$PATH"
export KB_VENDOR="tpacpi"
export GRIM_DEFAULT_DIR="$HOME/Pictures/Screenshots/"

#---------#
# Styling #
#---------#
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

#--------------#
# Utility Init #
#--------------#
eval "$(fzf --zsh)"

alias kboff='/home/lantzops/claude/input-toggle.sh'

# Dotfiles bare repo manager
alias config='/opt/homebrew/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

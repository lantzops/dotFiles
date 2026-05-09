# ~/.bashrc

# Skip non-interactive shells
[[ $- != *i* ]] && return

# PATH
export PATH="$HOME/.local/bin:$PATH"

# SSH agent: reuse existing agent across terminals via a saved env file
SSH_ENV="$HOME/.ssh/agent-env"
if [ -z "$SSH_AUTH_SOCK" ]; then
	[ -f "$SSH_ENV" ] && . "$SSH_ENV" >/dev/null
	ssh-add -l >/dev/null 2>&1
	if [ $? -eq 2 ]; then
		(umask 077; ssh-agent -s >"$SSH_ENV")
		. "$SSH_ENV" >/dev/null
		ssh-add ~/.ssh/id_ed25519 </dev/null
	fi
fi

# Aliases
alias kboff='/home/lantzops/claude/input-toggle.sh'
alias matrix='cmatrix -ab -u 4'

# Sudo askpass
export SUDO_ASKPASS=/usr/bin/lxqt-openssh-askpass

# Retro startup banner (only on interactive top-level shells)
if [[ $- == *i* ]] && [[ -z "$BANNER_SHOWN" ]] && [[ -z "$VSCODE_INJECTION" ]]; then
	export BANNER_SHOWN=1
	if command -v figlet >/dev/null && command -v lolcat >/dev/null; then
		figlet -f slant "welcome lantzops" | lolcat -F 0.3
	fi
	command -v pfetch >/dev/null && pfetch
fi

# Oh My Posh prompt (must be last)
if command -v oh-my-posh >/dev/null 2>&1; then
	eval "$(oh-my-posh init bash --config "$HOME/.cache/oh-my-posh/themes/dos-bbs.omp.json")"
fi

# Default editor
export EDITOR="vim"
export VISUAL="vim"

# Dotfiles bare repo manager
alias config='/opt/homebrew/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

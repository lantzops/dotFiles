source /usr/share/cachyos-fish-config/cachyos-config.fish

if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    ssh-add ~/.ssh/id_ed25519
end
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
export PATH="$HOME/.local/bin:$PATH"

alias kboff='/home/lantzops/claude/input-toggle.sh'

set -gx SUDO_ASKPASS /usr/bin/lxqt-openssh-askpass

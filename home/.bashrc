source ~/.bashrc-local
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source ~/.aliases

export PATH="$PATH:$HOME/.bin"
export EDITOR="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export MANPAGER="less"

HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ll:cd:pwd:clear:history"
shopt -s histappend

[[ -r /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
elif [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
fi

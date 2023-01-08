source ~/.bashrc-local
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source ~/.aliases

export PATH="$PATH:$HOME/.bin"
export EDITOR="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export MANPAGER="less"

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

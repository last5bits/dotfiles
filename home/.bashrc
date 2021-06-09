source ~/.bashrc-local
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source ~/.aliases

export PATH="$PATH:$HOME/.bin"
export EDITOR="/usr/bin/vim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export MANPAGER="env MAN_PN=1 vim -M +MANPAGER -c PAGER -"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

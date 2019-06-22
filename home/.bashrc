source ~/.bashrc-local
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source ~/.aliases

export PATH="$PATH:$HOME/.bin"
export EDITOR="/usr/bin/vim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export GIT_PAGER="vim - -R -c PAGER -c 'set filetype=git'"
export MANPAGER="env MAN_PN=1 vim -M +MANPAGER -c PAGER -"

# Prompt {{
bold=$(tput bold)
normal=$(tput sgr0)

PS1="[$bold\u$normal@$bold\h$normal \W$normal]\\$ "
PS2="$bold>$normal "
# }}

source ~/.bashrc-local
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source ~/.aliases

export PATH="$PATH:$HOME/.bin"
export EDITOR="/usr/bin/vim"

# Prompt {{
bold=$(tput bold)
normal=$(tput sgr0)

PS1="[$bold\u$normal@$bold\h$normal \W$normal]\\$ "
PS2="$bold>$normal "
# }}

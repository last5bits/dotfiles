source ~/.bashrc-local
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source ~/.aliases

export PATH="$PATH:$HOME/.bin"
export EDITOR="/usr/bin/vim"

# Prompt {{
exitstatus()
{
    local status=$? 
    if [[ $status != 0 ]]; then
        echo " $status"
    fi
}

bold=$(tput bold)
normal=$(tput sgr0)

PS1="[$bold\u$normal@$bold\h$normal \W$bold"'$(exitstatus)'"$normal]\\$ "
PS2="$bold>$normal "
# }}

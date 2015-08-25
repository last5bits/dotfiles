export EDITOR="vim"
PATH="$HOME/bin:$PATH"
source ~/.zshrc_specific
source ~/.homesick/repos/homeshick/homeshick.sh

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt hist_ignore_all_dups
setopt autocd
unsetopt beep
bindkey -e

zstyle :compinstall filename '/home/alex/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

autoload -Uz compinit promptinit
promptinit
compinit
prompt redhat

autoload -U colors && colors
PROMPT="[%{$fg_bold[default]%}%n%{$reset_color%}@%{$fg_bold[default]%}%m%{$reset_color%} %1~]%{$reset_color%}%(#.#.$) "
RPROMPT="[%{$fg_bold[default]%}%?%{$reset_color%}] "


# Open current line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line
bindkey "\e[3~" delete-char

# Run this in TTY
if [[ $DISPLAY = "" ]]
then
    alias mc="mc -S default"
fi

alias sudo="nocorrect sudo"
alias df="df -h"
alias ва="df -h"
alias ls="ls -h --color --group-directories-first"
alias ды="ls -h --color --group-directories-first"
alias ьс="mc"
alias св="cd"
alias p="ping ya.ru"
alias gdb="gdb -silent"
alias info="info --vi-keys"
alias wcc="wicd-curses"
alias rustime="export TZ=\"Europe/Moscow\" && date && unset TZ"
alias s="sync"

# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "       echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}
# Aliases / functions leveraging the cb() function
# ------------------------------------------------
# Copy contents of a file
function cbf() { cat "$1" | cb; }  
# Copy SSH public key
alias cbssh="cbf ~/.ssh/id_rsa.pub"  
# Copy current working directory
alias cbwd="pwd | cb"  
# Copy most recent command in bash history
alias cbhs="cat $HISTFILE | tail -n 1 | cb"

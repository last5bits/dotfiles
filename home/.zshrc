export EDITOR="vim"
PATH="$HOME/bin:$PATH"
source ~/.zshrc_specific

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
alias p="ping ya.ru"
alias gdb="gdb -silent"
alias info="info --vi-keys"
alias wcc="wicd-curses"
alias rustime="export TZ=\"Europe/Moscow\" && date && unset TZ"
alias s="sync"
alias homeshick="$HOME/.homesick/repos/homeshick/home/.homeshick"


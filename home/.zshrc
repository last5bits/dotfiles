# Lines configured by zsh-newuser-install
export EDITOR="vim"
PATH="$HOME/bin:$PATH"

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt hist_ignore_all_dups
setopt autocd
#setopt correctall
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
    loadkeys ru &>/dev/null
    setfont ter-v16v
    prompt bigfade
fi

# Start X at login
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx &>~/.xlog

alias sudo="nocorrect sudo"
alias Y="yaourt"
alias Sy="yaourt -Sy"
alias Syu="yaourt -Syu"
alias S="yaourt -S"
alias Ss="yaourt -Ss"
alias Rs="yaourt -Rs"
alias R="yaourt -R"
alias Qi="yaourt -Qi"
alias Ql="yaourt -Ql"
alias df="df -h"
alias ва="df -h"
alias ls="ls -h --color --group-directories-first"
alias ды="ls -h --color --group-directories-first"
alias ьс="mc"
alias p="ping ya.ru"
alias pingr="ping 192.168.1.1"
alias rc="sudo vim /etc/rc.conf"
alias sshdesktop="ssh alex@192.168.1.2"
alias gdb="gdb -silent"
alias info="info --vi-keys"
alias wcc="wicd-curses"
alias rustime="export TZ=\"Europe/Moscow\" && date && unset TZ"
alias chr="chromium"
alias s="sync"

alias homeshick="$HOME/.homesick/repos/homeshick/home/.homeshick"
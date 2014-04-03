#!/bin/bash

shopt -s histappend # multiple terminals don't clobber each others' history
shopt -s checkwinsize # update LINES and COLUMNS

if [[ $TERM != *-256color ]]; then
    POTENTIAL_TERM=${TERM}-256color
    # if a 256color terminfo is available for our terminal, switch to it
    toe -a | awk '{print $1}' | grep -Fxq $POTENTIAL_TERM && export TERM=$POTENTIAL_TERM
fi

# don't presume remote boxes will have 256-color terminfo files
[[ $TERM == *-256color ]] && alias ssh='TERM=${TERM%-256color} ssh'

case "$TERM" in
screen*|putty*|xterm*)
    source $HOME/.bash_prompt_colors
    source $HOME/.bash_prompt_vcs_colors
    source $HOME/.bash_git_prompt

    PS1='\[$USER_HOST_COLOR\]\u@\h '
    PS1=$PS1'\[$(get_vcs_pwd_color)\]\w\[$RESET\]'
    PS1=$PS1'$( $(is_vcs $git_mask) && echo -ne " $(prompt_git)" )'
    PS1=$PS1'$( (( \j > 0 )) && echo -ne " (\[$JOBS_COLOR\]\j\[$RESET\])" )'
    PS1=$PS1': '

    # set window title
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'

    # detect vcs for prompt coloring
    PROMPT_COMMAND=$PROMPT_COMMAND' && set_vcs_mask'

    # one newline before printing so our output has some breathing room
    PROMPT_COMMAND=$PROMPT_COMMAND' && echo'

    if $(type -P dircolors &>/dev/null); then
        eval $(dircolors -b)
        alias ls='ls --color=auto'
    else
        # On OS X, get pleasant light blue back for directories
        export CLICOLOR=1
        export LSCOLORS=Exfxcxdxbxegedabagacad
    fi
    ;;
*)
    PS1="\u@\h \w: "
    ;;
esac

source $HOME/.bash_aliases
source $HOME/.bash_functions

[[ -f /etc/bash_completion ]] && . /etc/bash_completion

[[ -f $HOME/.local/sh/.bashrc ]] && . $HOME/.local/sh/.bashrc

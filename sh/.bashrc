#!/bin/bash

shopt -s histappend # multiple terminals don't clobber each others' history
shopt -s checkwinsize # update LINES and COLUMNS

if [[ $TERM != *-256color ]]; then
    POTENTIAL_TERM=${TERM}-256color

    toe -a | awk '{print $1}' | grep -Fxq $POTENTIAL_TERM && export TERM=$POTENTIAL_TERM
fi

# don't presume remote boxes will have 256-color terminfo files
[[ $TERM == *-256color ]] && alias ssh='TERM=${TERM%-256color} ssh'

function should_mask_vcs {
    currdir=${PWD}
    vcs=$1

    while [[ -e "$currdir" ]]; do
        if [[ -d "$currdir/.$vcs" ]]; then
            return 0
        else
            currdir=${currdir%/*} # now check parent directory
        fi
    done

    return 1
}

svn_mask=$((1 << 0))
hg_mask=$((1 << 1))
git_mask=$((1 << 2))

VCS_MASK=0

function set_vcs_mask {
    VCS_MASK=0
    [[ -d .svn ]] && let "VCS_MASK |= $svn_mask"
    should_mask_vcs hg && let "VCS_MASK |= $hg_mask"
    should_mask_vcs git && let "VCS_MASK |= $git_mask"
}

function is_vcs {
    [[ $(($VCS_MASK & $1)) -ne 0 ]] && return 0
    return 1
}

VANILLA_PWD="\033[1;37m" # bold white
SVN_PWD="\033[1;48;5;234;38;5;51m" # bold light blue on dark gray
HG_PWD="\033[1;48;5;234;38;5;46m" # bold light green on dark gray
GIT_PWD="\033[1;48;5;234;38;5;196m" # bold red on dark gray
GIT_SVN_PWD="\033[1;48;5;234;38;5;163m" # bold purple on dark gray

function get_vcs_pwd_color {
    VCS_PWD=$VANILLA_PWD
    which_vcs=$1

    is_vcs $svn_mask && VCS_PWD=$SVN_PWD
    is_vcs $hg_mask  && VCS_PWD=$HG_PWD
    is_vcs $git_mask && VCS_PWD=$GIT_PWD
    is_vcs $git_mask && is_vcs $svn_mask && VCS_PWD=$GIT_SVN_PWD

    echo -e $VCS_PWD
}

function parse_git_branch {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

CYAN='\033[36m'
WHITE='\033[37;49m'
GREEN='\033[38;5;40m'
BRIGHT_WHITE_ON_DFLT_BG='\033[1;37;49m'
RESET_FORMATTING='\033[0m'

function set_color_prompt {
    # since bash decodes escapes including \[ and \] BEFORE running command
    # substitution, we can't call any functions that conditionally output
    # colors, because there would be no way for them to escape the color
    # commands correctly. these variables are basically functions that would be
    # called normally if bash decoded escapes AFTER doing command substitution,
    # but instead they are 'inlined' directly into the PS1 variable.

    PS1_JOBS='(( $(jobs | wc -l) > 0 )) && echo " (\j)"'
    PS1_RVM='(( $(rvm-prompt | wc -l) > 0 )) && echo -e "(\['$WHITE'\]$(rvm-prompt p)\['$BRIGHT_WHITE_ON_DFLT_BG'\]$(rvm-prompt g)\['$RESET_FORMATTING'\]) "'
    PS1_GIT='$(is_vcs $git_mask) && echo -e " (\['$GREEN'\]$(parse_git_branch)\['$RESET_FORMATTING'\])"'

    PS1="\[$CYAN\]\u@\h"
    PS1=$PS1' '
    PS1=$PS1'\[$(get_vcs_pwd_color)\]\w'
    PS1=$PS1"\[$RESET_FORMATTING\]"
    PS1=$PS1'$('$PS1_GIT')'
    PS1=$PS1"\[$BRIGHT_WHITE_ON_DFLT_BG\]"
    PS1=$PS1'$('$PS1_JOBS')'
    PS1=$PS1": \[$RESET_FORMATTING\]"

    [[ -s $HOME/.rvm/scripts/rvm ]] && PS1='$('$PS1_RVM')'$PS1
}

case "$TERM" in
screen*|putty*|xterm*)
    set_color_prompt
    # set window title
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    # detect vcs for prompt coloring
    PROMPT_COMMAND=$PROMPT_COMMAND' && set_vcs_mask'

    type -P dircolors &>/dev/null
    if [ "$?" -eq "0" ] ; then
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

# TODO: How do I know if '--exclude-dir' is supported? Munge -V output?
# export GREP_OPTIONS='-E -s --exclude-dir=.svn'

. $HOME/.bash_aliases
. $HOME/.bash_functions

[[ -f /etc/bash_completion ]] && . /etc/bash_completion

[[ -f $HOME/.local/sh/.bashrc ]] && . $HOME/.local/sh/.bashrc

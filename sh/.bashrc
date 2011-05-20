shopt -s histappend # multiple terminals don't clobber each others' history
shopt -s checkwinsize # update LINES and COLUMNS

case "$TERM" in
*-256color)
    alias ssh='TERM=${TERM%-256color} ssh'
    ;;
*)
    POTENTIAL_TERM=${TERM}-256color
    POTENTIAL_TERMINFO=${TERM:0:1}/$POTENTIAL_TERM

    # better to check $(toe -a | awk '{print $1}') maybe?
    BOX_TERMINFO_DIR=/usr/share/terminfo
    [[ -f $BOX_TERMINFO_DIR/$POTENTIAL_TERMINFO ]] && export TERM=$POTENTIAL_TERM

    HOME_TERMINFO_DIR=$HOME/.terminfo
    [[ -f $HOME_TERMINFO_DIR/$POTENTIAL_TERMINFO ]] && export TERM=$POTENTIAL_TERM
    ;;
esac

function is_vcs {
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

VANILLA_PWD="\033[1;37m" # bold white
SVN_PWD="\033[1;48;5;234;38;5;46m" # bold light green on dark gray
HG_PWD="\033[1;48;5;234;38;5;51m" # bold light blue on dark gray
GIT_PWD="\033[1;48;5;234;38;5;196m" # bold red on dark gray

function get_vcs_pwd_color {
    VCS_PWD=$VANILLA_PWD

    [[ -d .svn ]] && VCS_PWD=$SVN_PWD
    is_vcs hg  && VCS_PWD=$HG_PWD
    is_vcs git && VCS_PWD=$GIT_PWD

    echo -e $VCS_PWD
}

function set_color_prompt {
    PS1_JOBS='(( $(jobs | wc -l) > 0 )) && echo " ($(jobs | wc -l))"'

    GREEN='\033[36m'
    BRIGHT_WHITE_ON_DFLT_BG='\033[1;37;49m'
    RESET_FORMATTING='\033[0m'

    # \[ \] are required to tell bash that the escapes do not move the cursor

    PS1="\[$GREEN\]\u@\h"
    PS1=$PS1' '
    PS1=$PS1'\[$(eval get_vcs_pwd_color)\]\w'
    PS1=$PS1"\[$BRIGHT_WHITE_ON_DFLT_BG\]"
    PS1=$PS1'$(eval $PS1_JOBS)'
    PS1=$PS1": \[$RESET_FORMATTING\]"
}

case "$TERM" in
screen*|putty*|xterm*)
    set_color_prompt
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'

    eval $(dircolors -b)
    alias ls='ls --color=auto'
    ;;
*)
    PS1="\u@\h \w: "
    ;;
esac

. $HOME/.bash_aliases
. $HOME/.bash_functions

[[ -f /etc/bash_completion ]] && . /etc/bash_completion
[[ -s $HOME/.rvm/scripts/rvm ]] && . $HOME/.rvm/scripts/rvm
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

[[ -f $HOME/.local/sh/.bashrc ]] && . $HOME/.local/sh/.bashrc

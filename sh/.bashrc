#!/bin/bash

shopt -s histappend # multiple terminals don't clobber each others' history
shopt -s checkwinsize # update LINES and COLUMNS

if [[ $TERM != *-256color ]]; then
    POTENTIAL_TERM=${TERM}-256color

    toe -a | awk '{print $1}' | grep -Fxq $POTENTIAL_TERM && export TERM=$POTENTIAL_TERM
fi

# Terminal Foregrounds
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)

# Formatting
BOLD=$(tput bold)

# 256-color Foregrounds
LIGHT_BLUE=$(tput setaf 51)
LIGHT_GREEN=$(tput setaf 46)
CRIMSON=$(tput setaf 196)
BRIGHT_WHITE='\033[1;37m'

# 256-color Backgrounds
BG_DARK_GRAY=$(tput setab 234)

# Basic Prompt
USER_HOST_COLOR="$CYAN"
JOBS_COLOR="$BRIGHT_WHITE"

# Directory
VANILLA_PWD="$WHITE"
SVN_PWD="${BG_DARK_GRAY}${BOLD}${LIGHT_BLUE}"
HG_PWD="${BG_DARK_GRAY}${BOLD}${LIGHT_GREEN}"
GIT_PWD="${BG_DARK_GRAY}${BOLD}${CRIMSON}"

# git
GIT_BRANCH_COLOR=$GREEN
GIT_DETACHED_COLOR=$YELLOW
GIT_ACTIVITY_COLOR=$(tput setab 17)$(tput setaf 141)

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

# use a mask so we can communicate multiple VCS control in a single dir
# in case we're dealing with fucked repos that have .git and .svn
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

function get_vcs_pwd_color {
    VCS_PWD=$VANILLA_PWD

    is_vcs $svn_mask && VCS_PWD=$SVN_PWD
    is_vcs $hg_mask && VCS_PWD=$HG_PWD
    is_vcs $git_mask && VCS_PWD=$GIT_PWD

    echo -e $VCS_PWD
}

function prompt_git_activity {
    g="$1"

    # shamelessly gank from official git repo's __git_ps1

    if [ -d "$g/rebase-merge" ]; then
        #read head_name 2>/dev/null <"$g/rebase-merge/head-name"
        read step 2>/dev/null <"$g/rebase-merge/msgnum"
        read total 2>/dev/null <"$g/rebase-merge/end"
        if [ -f "$g/rebase-merge/interactive" ]; then
            act_message="REBASE-i"
        else
            act_message="REBASE-m"
        fi
    else
        if [ -d "$g/rebase-apply" ]; then
            read step 2>/dev/null <"$g/rebase-apply/next"
            read total 2>/dev/null <"$g/rebase-apply/last"
            if [ -f "$g/rebase-apply/rebasing" ]; then
                #read head_name 2>/dev/null <"$g/rebase-apply/head-name"
                act_message="REBASING"
            elif [ -f "$g/rebase-apply/applying" ]; then
                act_message="AM"
            else
                act_message="AM/REBASE"
            fi
        elif [ -f "$g/MERGE_HEAD" ]; then
            act_message="MERGING"
        elif [ -f "$g/CHERRY_PICK_HEAD" ]; then
            act_message="CHERRY-PICKING"
        elif [ -f "$g/REVERT_HEAD" ]; then
            act_message="REVERTING"
        elif [ -f "$g/BISECT_LOG" ]; then
            act_message="BISECTING"
        fi
    fi

    if [ -n "$step" ] && [ -n "$total" ]; then
        act_message="$act_message $step/$total"
    fi

    [ -n "$act_message" ] && echo -ne "\x01${GIT_ACTIVITY_COLOR}\x02$act_message\x01${RESET}\x02"
}

function prompt_git_branch {
    g="$1"

    read head <"$g/HEAD"
    branch=${head#ref: }

    if [ "$head" = "$branch" ]; then
        # detached
        branch=$(git describe --contains --all HEAD)
        detached=$(git rev-parse --short HEAD)
    else
        branch=${branch##refs/heads/}
    fi

    echo -ne "\x01${GIT_BRANCH_COLOR}\x02${branch}\x01${RESET}\x02"
    [ -n "$detached" ] && echo -ne "|\x01${GIT_DETACHED_COLOR}\x020${detached}\x01${RESET}\x02"
}

function prompt_git_changes {
    mode='symbols' # count, symbols

    num_staged=$(git diff --cached --numstat | wc -l | tr -d ' ')
    num_unstaged=$(git diff --numstat | wc -l | tr -d ' ')
    num_untracked=$(git ls-files --others --exclude-standard | wc -l | tr -d ' ')

    STAGED_COLOR=$BG_DARK_GRAY$(git config --get-color color.status.added green)
    UNSTAGED_COLOR=$BG_DARK_GRAY$(git config --get-color color.status.changed red)
    UNTRACKED_COLOR=$BG_DARK_GRAY$(git config --get-color color.status.untracked red)

    case "$mode" in
        count)
            staged=$num_staged
            unstaged=$num_unstaged
            untracked=$num_untracked
            ;;
        symbols)
            staged="+"
            unstaged="!"
            untracked="?"
            ;;
    esac

    # turns out there IS a way to escape colors from within a function, and it's
    # using \x01 and \x02. however, trying to output numbers directly after \x02
    # causes the first digit of the number to be consumed, so there is a 0 after
    # each \x02 before the variable in each line of output below. I have no idea
    # why it works, but it works :-(

    delimiter='|'
    count=0

    [ "$num_staged" -gt "0" ] && (( count+=1 )) && echo -ne "\x01${STAGED_COLOR}\x02${staged}\x01${RESET}\x02"
    [ "$num_unstaged" -gt "0" ] && [ "$count" -gt "0" ] && echo -ne "$delimiter"
    [ "$num_unstaged" -gt "0" ] && (( count+=1 )) && echo -ne "\x01${UNSTAGED_COLOR}\x02${unstaged}\x01${RESET}\x02"
    [ "$num_untracked" -gt "0" ] && [ "$count" -gt "0" ] && echo -ne "$delimiter"
    [ "$num_untracked" -gt "0" ] && (( count+=1 )) && echo -ne "\x01${UNTRACKED_COLOR}\x02${untracked}\x01${RESET}\x02"
}

function prompt_git {
    # ask git for the git directory since we might be in a subdir
    g=$(git rev-parse --git-dir)

    branch=$(prompt_git_branch "$g")
    changes=$(prompt_git_changes)
    activity=$(prompt_git_activity "$g")

    echo -ne "("
    echo -ne "$branch"
    [ -n "$activity" ] && echo -ne "|$activity"
    echo -ne ")"
    [ -n "$changes" ] && echo -ne " [$changes]"
}

function set_color_prompt {
    PS1='\[$USER_HOST_COLOR\]\u@\h '
    PS1=$PS1'\[$(get_vcs_pwd_color)\]\w\[$RESET\]'
    PS1=$PS1'$( $(is_vcs $git_mask) && echo -ne " $(prompt_git)" )'
    PS1=$PS1'$( (( $(jobs | wc -l) > 0 )) && echo -ne " (\[$JOBS_COLOR\]\j\[$RESET\])" )'
    PS1=$PS1': '
}

case "$TERM" in
screen*|putty*|xterm*)
    # define color prompt command
    set_color_prompt

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

# TODO: How do I know if '--exclude-dir' is supported? Munge -V output?
# export GREP_OPTIONS='-E -s --exclude-dir=.svn'

. $HOME/.bash_aliases
. $HOME/.bash_functions

[[ -f /etc/bash_completion ]] && . /etc/bash_completion

[[ -f $HOME/.local/sh/.bashrc ]] && . $HOME/.local/sh/.bashrc

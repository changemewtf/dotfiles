# Default customization location
[ ! -f $HOME/.dotfile_directory ] && echo '.common-public' > $HOME/.dotfile_directory

# Most customization stuff is in here.
DOTFILE_DIR_NAME=$(<$HOME/.dotfile_directory)
DOTFILE_DIR="$HOME/$DOTFILE_DIR_NAME"

# Set some basic shell options
HISTCONTROL='ignorespace:erasedups' # tweak what gets added to history
shopt -s histappend # multiple terminals don't clobber each others' history
shopt -s checkwinsize # update LINES and COLUMNS

# if a 256color terminfo is available for our terminal, switch to it
if [[ $TERM != *-256color ]]; then
    POTENTIAL_TERM=${TERM}-256color
    toe -a | awk '{print $1}' | grep -Fxq $POTENTIAL_TERM && TERM=$POTENTIAL_TERM
fi

# don't presume remote boxes will have 256-color terminfo files
[[ $TERM == *-256color ]] && alias ssh='TERM=${TERM%-256color} ssh'

# set up my sweet shell prompt
source $DOTFILE_DIR/sh/sweet_bash_prompt

# source convenient things
source $DOTFILE_DIR/sh/bash_aliases
source $DOTFILE_DIR/sh/bash_functions

# setup completion if available
[ -f /etc/bash_completion ] && source /etc/bash_completion

# platform-specific stuff
[ $(uname -s) = "Darwin" ] && source $DOTFILE_DIR/sh/osx_setup

export DOTFILE_DIR

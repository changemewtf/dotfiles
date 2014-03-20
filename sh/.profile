export PATH=/usr/local/bin:$HOME/.common-public/bin:$HOME/.common-private/bin:$HOME/.local/bin:$PATH
export EDITOR='vim'
export PATCH_DIR=$HOME/.patches
export PATCH_BACKUP_DIR=$HOME/.pbackup
export HISTCONTROL=ignorespace:erasedups

if [ `uname -s` = "Darwin" ]; then
    # for building ruby on OS X Lion; apparently it doesn't like llvm
    export CC=gcc-4.2
    export PATH=$PATH:/usr/local/sbin

    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
fi

[[ -f ~/.local/sh/.profile ]] && . ~/.local/sh/.profile

eval "$(rbenv init -)"

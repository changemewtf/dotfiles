export PATH=/usr/local/bin:$HOME/bin:$HOME/.common/bin:$PATH
export EDITOR='vim'
export GEMS=/usr/local/lib/ruby/gems
export PATCH_DIR=$HOME/.patches
export PATCH_BACKUP_DIR=$HOME/.pbackup
export HISTCONTROL=ignorespace:erasedups
export SRC=$HOME/code

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

export PATH=/usr/local/bin:$HOME/.common-public/bin:$HOME/.common-private/bin:$HOME/.local/bin:$PATH
export EDITOR='vim'
export PATCH_DIR=$HOME/.patches
export PATCH_BACKUP_DIR=$HOME/.pbackup
export HISTCONTROL=ignorespace:erasedups

if [ `uname -s` = "Darwin" ]; then
    # for building ruby on OS X Lion; apparently it doesn't like llvm
    export CC=gcc-4.2
    export PATH=$PATH:/usr/local/sbin
    export NODE_PATH=/usr/local/lib/node_modules

    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
fi

[[ -f ~/.local/sh/.profile ]] && . ~/.local/sh/.profile
[[ -f ~/.api_keys ]] && . ~/.api_keys

if hash rbenv 2>/dev/null; then
    eval "$(rbenv init -)"
fi

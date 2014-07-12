export PATH=/usr/local/bin:$HOME/.common-public/bin:$HOME/.common-private/bin:$HOME/.local/bin:$PATH
export EDITOR='vim'
export HISTCONTROL=ignorespace:erasedups

# when using PuTTY on Windows 7 to connect to my Macbook Air, vim complains
# that the ¬ character is an invalid argument to the 'listchars' option if
# its 'encoding' is 'latin-1', but setting this environment variable causes
# vim to use 'utf-8' as the value of 'encoding', which fixes the issue.
# I'm not sure why this doesn't happen when sshing from PuTTY... it probably
# has to do with the env set by local login shells vs. those created by the
# ssh daemon.
#
# it seems like this affects a lot of other shell utilities as well, including
# git: running 'git diff' before checking in this change results in <C2><AC>
# instead of the nbsp character, but running 'LANG=en_US.utf-8 git diff' shows
# the correct output.
export LANG='en_US.utf-8'

if [ `uname -s` = "Darwin" ]; then
    export CC=/usr/bin/gcc
    export PATH=$PATH:/usr/local/sbin
    export NODE_PATH=/usr/local/lib/node_modules

    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
fi

[[ -f ~/.local/sh/.profile ]] && . ~/.local/sh/.profile
[[ -f ~/.local/sh/.api_keys ]] && . ~/.local/sh/.api_keys

if hash rbenv 2>/dev/null; then
    eval "$(rbenv init -)"
fi

if hash pyenv 2>/dev/null; then
    eval "$(pyenv init -)"
fi

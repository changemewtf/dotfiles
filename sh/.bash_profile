# .bashrc is read automatically by non-login shells, but most terminal clients
# (including iTerm2 and tmux) launch bash as a login shell, so we need to
# manually source it here.
#
# An example of a non-login shell is if you type "bash" into a bash prompt and
# hit enter. The "inner", or "child" process will not be a login shell, and
# thus it will read .bashrc directly while skipping this file.
source ~/.bashrc

# Obviously.
EDITOR='vim'

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
LANG='en_US.utf-8'

# Load local private API keys
[[ -f ~/.local/sh/api_keys ]] && . ~/.local/sh/api_keys

# Just override the stupid path
PATH=$DOTFILE_DIR'/bin'
PATH+=':/usr/local/bin'
PATH+=':/usr/bin'
PATH+=':/bin'
PATH+=':/usr/sbin'
PATH+=':/sbin'
PATH+=':/opt/X11/bin'

# These together add a noticeable delay to shell startup time. I kinda want to
# take them out and just manually run them as needed, but that seems awfully
# pedantic even to me.
hash rbenv 2>/dev/null && eval "$(rbenv init -)"
hash pyenv 2>/dev/null && eval "$(pyenv init -)"

# Since this file is supposedly read only once per login session, its variables
# are exported so that child processes (including other bash sessions) will
# have access to them.
export PATH EDITOR LANG

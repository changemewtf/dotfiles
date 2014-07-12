# vim:ft=sh

alias tmux-betteraria='Dropbox/Documents/code/tmux-scripts/tmux-betteraria'
alias cdg='cd $(git root)'
alias tree='tree -Ca --noreport'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='. ~/.bashrc'
alias stripescapes='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias vi='vim'
alias path='echo $PATH | tr ":" "\n"'
alias pythonpath='echo $PYTHONPATH | tr ":" "\n"'
alias :q='logout'
alias :e='vim'
alias ,e='vim $HOME/.vimrc'
alias which='type -a'
alias wget='wget --content-disposition'
alias loc="find . -type f -iname \"*.rb\" -exec cat {} \; | sed '/^\s*#/d;/^\s*$/d' | wc -l"
function diffcount { egrep -v "^[-+]{3}" | egrep -o "^[-+]" | sort | uniq -c; } # to be piped after a diff
function netlines { awk "/-/ { del=\$1 } /+/ { add=\$1 } END { print add - del }"; } # to be piped after diffcount()
function zipit { zip -r $1 $2 --exclude \*\.svn/\*; }
function :he { vim -c ":he $1" -c :only; }

if [ `uname -s` = "Darwin" ]; then
    alias msyql_stop='sudo /usr/local/mysql/support-files/mysql.server stop'

    if [[ $TERM == screen-* ]]; then
        if hash reattach-to-user-namespace 2>/dev/null; then
            alias vim='reattach-to-user-namespace -l vim'
        else
            echo 'System clipboard will not function in vim.' > ~/.WARNING
        fi
    fi
fi


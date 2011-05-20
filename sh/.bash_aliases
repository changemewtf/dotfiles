# vim:ft=sh

alias allup='sudo aptitude update && sudo aptitude safe-upgrade'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias lightest='lighttpd -t -f /etc/lighttpd/lighttpd.conf'
alias lightprint='lighttpd -p -f /etc/lighttpd/lighttpd.conf'
alias lsc='screen -list'
alias scr='screen -rd'
alias scx='screen -x'
alias ..='. ~/.bashrc'
alias stripescapes='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias svex='svn propedit svn:externals'
alias svig='svn propedit svn:ignore'
alias svl='svn propedit svn:log --revprop -rHEAD'
alias sv?='svn stat | grep ^? | sed -e "s/^?\s*//"'
alias svdiff='svn diff --diff-cmd=diff'
alias vi='vim'
alias path='echo $PATH | sed -e "s/:/\n/g"'
alias pythonpath='echo $PYTHONPATH | sed -e "s/:/\n/g"'
alias :e='vim'
alias ,e='vim $HOME/.vimrc'
alias which='type -a'
function diffcount { egrep -v "^[-+]{3}" | egrep -o "^[-+]" | sort | uniq -c; } # to be piped after a diff
function netlines { awk "/-/ { del=\$1 } /+/ { add=\$1 } END { print add - del }"; } # to be piped after diffcount()
function zipit { zip -r $1 $2 --exclude \*\.svn/\*; }
function :he { vim -c ":he $1" -c :only; }

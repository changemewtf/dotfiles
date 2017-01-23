# vim: ft=tmux

unbind-key q
# sleep to wait for vim and servers to finish closing
bind-key q if-shell "tmux list-windows | cut -d' ' -f2 | grep srv" "send-keys -t srv C-c" \; send-keys -t lib ":call MySessionSave()" C-m \; run-shell "sleep 0.1" \; kill-session

set-window-option -g automatic-rename off

rename-window git
send-keys "tree" C-m
send-keys "git status" C-m

new-window -n lib
send-keys "if [ -e .session.vim ]; then vim -S .session.vim; else vim -c NERDTree; fi" C-m

new-window -n bash

# use single quotes instead of double to prevent premature variable expansion
# tmux doesn't actually respect session env variables within sourced conf files
if-shell 'cd $PROGRAMMING_SUCKS && test -d spec' "new-window -n spec ; send-keys 'bundle exec rspec' C-m"

new-window -n search -t 8 ; send-keys 'test -e .searchrc && source .searchrc' C-m 'clear' C-m
bind-key g select-window -t search

new-window -n srv -t 9

if-shell 'cd $PROGRAMMING_SUCKS && test -e Procfile' "select-window -t srv ; send-keys 'foreman start' C-m"

select-window -t lib

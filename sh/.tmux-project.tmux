# vim: ft=tmux

unbind-key q
# sleep to wait for vim to finish closing
bind-key q send-keys -t lib ":call MySessionSave()" C-m \; run-shell "sleep 0.1" \; kill-session

set-window-option -g automatic-rename off

rename-window git
send-keys "git status" C-m

new-window -n lib
send-keys "if [ -e .session.vim ]; then vim -S .session.vim; else vim; fi" C-m

new-window -n bash

# use single quotes instead of double to prevent premature variable expansion
# tmux doesn't actually respect session env variables within sourced conf files
if-shell 'cd $PROGRAMMING_SUCKS && test -d spec' "new-window -n spec ; send-keys 'bundle exec rspec' C-m"
if-shell 'cd $PROGRAMMING_SUCKS && test -e Procfile' "new-window -n srv -t 9 ; send-keys 'foreman start' C-m"

select-window -t git

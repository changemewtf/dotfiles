unbind-key q
bind-key q send-keys -t lib ":Q" C-m \; kill-session

set-window-option -g automatic-rename off

rename-window git
send-keys "git status" C-m

new-window -n lib
send-keys "if [ -e .session.vim ]; then reattach-to-user-namespace vim -S .session.vim; else vim; fi" C-m

new-window -n bash

select-window -t git

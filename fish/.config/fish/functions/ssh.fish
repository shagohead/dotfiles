function ssh -d "Call SSH with TERM env invoked"
    tmux rename-window "@$argv"
    TERM=xterm-256color command ssh $argv
    tmux set automatic-rename on
end

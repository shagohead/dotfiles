function ssh -d "Call SSH with TERM env invoked"
    TERM=xterm-256color command ssh $argv
end

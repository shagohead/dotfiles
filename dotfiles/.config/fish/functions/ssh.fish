function ssh -d "SSH wrapper with TERM env invoked"
    TERM=xterm-256color command ssh $argv
end

function tunnel \
    --description "ssh tunnel. parameter format: forwarding_addr ssh_server"

    set -l session_name "tunnels"
    set -l cmd "ssh -L $argv"

    if tmux has-session -t $session_name 2>/dev/null
        tmux new-window -dS -t $session_name -n "$argv[1]" $cmd
    else
        tmux new-session -d -s $session_name -n "$argv[1]" $cmd
    end
end

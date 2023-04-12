function __tunnel_kill
    tmux list-windows -F '#I|#W' -t sshtunnels | grep "^\d|$argv\$" | awk -F "|" '{ print $1 }' | read -l idx
    if test -n "$idx"
        tmux kill-window -t "sshtunnels:$idx"
    end
end

function __tunnel_open
    if tmux has-session -t sshtunnels 2>/dev/null
        tmux new-window -dS -t sshtunnels -n "$argv" -- "ssh -L $argv"
    else
        tmux new-session -d -s sshtunnels -n "$argv" -- "ssh -L $argv"
    end
    sleep 1
end

function tunnel -d "Open or close SSH tunnel"
    argparse 'h/help' -- $argv
    or return

    if test -n "$_flag_help"
        printf "Add tunnels with universal list variable `tunnel_list`:\n"
        printf "> set -U tunnel_list \$tunnel 'SSH_TUNNEL_ARGV'\n"
        return
    end

    if test "$argv[1]" = "close"
        echo "Closing $argv[2]"
        __tunnel_kill "$argv[2]"
        return
    end

    if test "$argv[1]" = "reopen"
        echo "Reopening $argv[2]"
        __tunnel_kill "$argv[2]"
        __tunnel_open "$argv[2]"
        return
    end

    echo "Starting $argv"
    __tunnel_open $argv
end

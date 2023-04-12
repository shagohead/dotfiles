function __tunnel_all_list
    for tunnel in $tunnel_list
        printf "$tunnel\n"
    end
end

function __tunnel_active_list
    if tmux has-session -t sshtunnels 2>/dev/null
        for tunnel in $tunnel_list
            if tmux list-windows -F '#W' -t sshtunnels | grep -q "^$tunnel\$"
                printf "$tunnel\n"
            end
        end
    end
end

set -l commands close reopen

complete -c tunnel -f
complete -c tunnel -n "not __fish_seen_subcommand_from $commands" -l help
complete -c tunnel -n "not __fish_seen_subcommand_from $commands" -a "$commands (__tunnel_all_list)"
complete -c tunnel -n "__fish_seen_subcommand_from $commands" -a "(__tunnel_active_list)"

function tunnel -d "SSH tunnel manager based on tmux windows"
    argparse 'e/edit' 'h/help' -- $argv
    or return

    set -l confpath $HOME/.local/shell/tunnels
    set -q tunnels_session; or set -l tunnels_session tunnels
    set -q tunnels_port_range; or set -l tunnels_port_range 50000 50100
    set -q tunnels_sleep; or set -l tunnels_sleep 0.2

    if test -n "$_flag_help"
        echo "usage: tunnel [-e | --edit] [-h | --help] [<tunnel-name>]

If tunnel name is not provided, fzf will be invoked for tunnel selection.

Port for tunnel will be used in range defined by \$tunnels_port_range variable.
Default range is: 50000 50100.

Tunnels are stored in $confpath.
Edit that file directly or use tunnel command with -e/--edit option.

Each line in file is a tunnel specification:

tunnel-spec = name \"\t\" ssh-arguments;
name = (non-tabular-symbol) +;
ssh-arguments = target-host \":\" target-port \" \" ssh-tunnel-conn-string;
"
        return
    end

    if test -n "$_flag_edit"
        $EDITOR $confpath
        return
    end

    set -l name
    if test -n "$argv[1]"
        set name $argv[1]
    else
        cat $confpath | awk -F\t '{print $1}' | fzf | read name; or return 0
    end

    grep "^$name" $confpath | awk -F\t '{print $2}' | read -l remote
    if test -z "$remote"
        echo "$name not found in $confpath"
        return 1
    end

    set -l port
    tmux list-windows -f "#{==:#W,$name}" -F '#{pane_start_command}' -t $tunnels_session 2>/dev/null | read -l ssh_cmd
    if test -n "$ssh_cmd"
        echo $ssh_cmd | awk '{print $4}' | awk -F: '{print $1}' | read port
        if test -z "$port"
            echo "Not found port in window $name command. Probably that window opened not by tunnel command."
            return 1
        end
        echo $port
        return
    end

    for i in (seq $tunnels_port_range)
        if not nc -z localhost $i 2>/dev/null
            set port $i
            break
        end
    end

    if test -z "$port"
        echo "Not found closed port in range."
        return 1
    end


    set ssh_cmd "ssh -N -L $port:$remote"
    if tmux has-session -t $tunnels_session 2>/dev/null
        tmux new-window -dS -t $tunnels_session -n $name $ssh_cmd
    else
        tmux new-session -d -s $tunnels_session -n $name $ssh_cmd
    end

    if test -n "$tunnels_sleep"
        sleep $tunnels_sleep
        tmux list-windows -f "#{==:#W,$name}" -t $tunnels_session 2>/dev/null | read -l found
        if test -z "$found"
            echo "Window suddenly died. Check ssh command argument for $name."
            return 1
        end
    end

    echo $port
    return
end

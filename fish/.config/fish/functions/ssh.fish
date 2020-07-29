function ssh -d "Call SSH with TERM env invoked & tmux set tmux title"
    set -l rename_window 0
    if test "$TMUX" != ""
        set -l automatic_rename (tmux show -v automatic-rename)
        if test "$automatic_rename" != "off"
            set rename_window 1
        end
    end

    if test $rename_window -eq 1
        tmux rename-window "@$argv"
    end

    TERM=xterm-256color command ssh $argv

    if test $rename_window -eq 1
        tmux set automatic-rename on
    end
end

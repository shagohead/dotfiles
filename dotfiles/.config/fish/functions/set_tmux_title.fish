function set_tmux_title -d "Set current working dir basename to TMUX window title"
    tmux rename-window (basename (pwd))
end

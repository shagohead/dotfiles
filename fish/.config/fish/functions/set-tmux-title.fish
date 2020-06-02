function set-tmux-title
    tmux rename-window (basename (pwd))
end

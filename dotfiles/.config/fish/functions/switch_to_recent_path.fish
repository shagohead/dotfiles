function switch_to_recent_path -d "Switch TMUX session to recent path"
    set -l path
    cat $HOME/.local/share/z/data | awk -F\| '{print $1}' | fzf | read path; or return 0

    set -l name (basename $path)
    if not tmux has-session -t=$name 2>/dev/null
        tmux new -s $name -c $path -d
    end

    tmux switch-client -t $name
end

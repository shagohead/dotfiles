function help_menu
    echo 'nvim -c "help | only" #  nvim help
tmux send-prefix; and tmux send-keys "?" #  tmux keymaps (C-s ?)
    ' | fzf | read -l comm; and eval $comm
end

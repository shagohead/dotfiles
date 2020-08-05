set -l system_completions $__fish_data_dir/completions/tmux.fish
if test -e $system_completions
    source $system_completions
end

set -l buffer_commands \
    delete-buffer deleteb \
    list-buffers lsb \
    load-buffer loadb \
    paste-buffer pasteb \
    save-buffer saveb \
    set-buffer setb \
    show-buffer showb
complete -c tmux -a (string join " " $buffer_commands)
complete -c tmux -n "__fish_seen_subcommand_from $buffer_commands" -s b -d "Buffer name" -a "(tmux list-buffers -F#{buffer_name} | xargs -0)"

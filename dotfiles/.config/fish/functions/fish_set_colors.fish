# https://fishshell.com/docs/current/interactive.html#syntax-highlighting-variables
function fish_set_colors -d "Set fish color variables"
    set -U fish_color_normal normal
    set -U fish_color_command blue # commands like echo
    set -U fish_color_keyword cyan # keywords like if - this falls back on the command color if unset
    set -U fish_color_quote green # quoted text like "abc"
    set -U fish_color_redirection brmagenta # IO redirections like '>/dev/null'
    set -U fish_color_end magenta # process separators like ';' and '&'
    set -U fish_color_error red # syntax errors
    set -U fish_color_param normal # ordinary command parameters
    set -U fish_color_valid_path --underline # parameters that are filenames (if the file exists)
    set -U fish_color_option --bold # # options starting with “-”, up to the first “--” parameter
    set -U fish_color_comment brblack # comments like ‘# important’
    set -U fish_color_search_match --background=brblack # history search matches and the selected pager item (must be a background)
    set -U fish_color_selection bryellow --bold --background=brblack # selected text in vi visual mode
    set -U fish_color_history_current --bold # the current position in the history for commands like dirh and cdh
    set -U fish_color_operator magenta # parameter expansion operators like '*' and '~'
    set -U fish_color_escape magenta # character escapes like '\n' and '\x70'
    set -U fish_color_autosuggestion -d # autosuggestions (the proposed rest of a command)
    set -U fish_color_status red # the last command’s nonzero exit code in the default prompt
    set -U fish_color_cancel brred # the '^C' indicator on a canceled command
    set -U fish_color_cwd brblue # the current working directory in the default prompt
    set -U fish_color_cwd_root brred # the current working directory in the default prompt for the root user
    set -U fish_color_user brcyan # the current username in some of fish default prompts
    set -U fish_color_host brblue # the current host system in some of fish default prompts
    set -U fish_color_host_remote yellow # the hostname in the default prompt for remote sessions (like ssh)
    # NOTE: did not work
    set -U fish_color_match --background=cyan # matching parenthesis

    # Pager color variables.
    # https://fishshell.com/docs/current/interactive.html#pager-color-variables
    set -U fish_pager_color_prefix white --underline # prefix string, i.e. the string that is to be completed
    set -U fish_pager_color_completion normal # the completion itself
    set -U fish_pager_color_description bryellow # the completion description
    set -U fish_pager_color_progress brcyan # the progress bar at the bottom left corner
    set -U fish_pager_color_selected_background -r # background of the selected completion
end

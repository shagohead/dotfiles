# colors
# the default color
# set -q fish_color_normal; or set -U fish_color_normal normal
# # the color for commands
# set -q fish_color_command; or set -U fish_color_command blue
# # the color for quoted blocks of text
# set -q fish_color_quote; or set -U fish_color_quote green
# # the color for IO redirections
# set -q fish_color_redirection; or set -U fish_color_redirection brmagenta
# # the color for process separators like ';' and '&'
# set -q fish_color_end; or set -U fish_color_end magenta
# # the color used to highlight potential errors
# set -q fish_color_error; or set -U fish_color_error red
# # the color for regular command parameters
# set -q fish_color_param; or set -U fish_color_param normal
# # the color used for code comments
# set -q fish_color_comment; or set -U fish_color_comment brblack
# # the color used to highlight matching parenthesis
# set -q fish_color_match; or set -U fish_color_match --background=cyan
# # the color used when selecting text (in vi visual mode)
# set -q fish_color_selection; or set -U fish_color_selection green
# # used to highlight history search matches and the selected pager item (must be a background)
# set -q fish_colorsearch_match; or set -U fish_colorsearch_match --background=brblack
# # the color for parameter expansion operators like '*' and '~'
# set -q fish_color_operator; or set -U fish_color_operator magenta
# # the color used to highlight character escapes like '\n' and '\x70'
# set -q fish_color_escape; or set -U fish_color_escape magenta
# # the color used for the current working directory in the default prompt
# set -q fish_color_cwd; or set -U fish_color_cwd brblue
# # the color used for autosuggestions
# set -q fish_color_autosuggestion; or set -U fish_color_autosuggestion -d
# # the color used to print the current username in some of fish default prompts
# set -q fish_color_user; or set -U fish_color_user brcyan
# # the color used to print the current host system in some of fish default prompts
# set -q fishcolor_host; or set -U fishcolor_host brblue
# # the color for the '^C' indicator on a canceled command
# set -q fish_color_cancel; or set -U fish_color_cancel brred
# # the color of the prefix string, i.e. the string that is to be completed
# set -q fish_pager_color_prefix; or set -U fish_pager_color_prefix white --underline
# # # the color of the completion itself
# # set -q fish_pager_color_completion; or set -U fish_pager_color_completion
# # the color of the completion description
# set -q fish_pager_color_description; or set -U fish_pager_color_description bryellow
# # the color of the progress bar at the bottom left corner
# set -q fish_pager_color_progress; or set -U fish_pager_color_progress brcyan
# # # the background color of the every second completion
# # set -q fish_pager_color_secondary; or set -U fish_pager_color_secondary

#################
# Common config #
#################

if test -n "$ALACRITTY_LOG"
    set -x TERM alacritty
end

set -x EDITOR vi
set -x VISUAL nvim
set -x LS_COLORS ''
set -x PAGER less -R
set -x MANPAGER 'less -R --use-color -Dd+b -Du+g'

set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

# Python development
set -x PIPENV_VENV_IN_PROJECT 1
set -x PYENV_ROOT $HOME/.pyenv
set -x PYENV_SHELL fish
set -x PYTEST_ADDOPTS --reuse-db --pdbcls=IPython.terminal.debugger:TerminalPdb

# GO development
set -q GOPATH; or set -xU GOPATH $HOME/go

# PATH
set -gx PATH $HOME/.local/bin $HOME/.cargo/bin $GOPATH/bin $HOME/.pyenv/shims $HOME/yandex-cloud/bin /usr/local/opt/curl/bin $PATH

################
# Tools config #
################

# check-list
set -q HOMEBREW_GITHUB_API_TOKEN; or echo 'set -xU HOMEBREW_GITHUB_API_TOKEN ...'

# https://support.apple.com/ru-ru/HT208050
set -x BASH_SILENCE_DEPRECATION_WARNING 1

# bat
set -x BAT_STYLE plain
set -x BAT_THEME ansi

# FZF
set -q FZF_DEFAULT_OPT; or set -U FZF_DEFAULT_OPTS \
" --bind=ctrl-d:half-page-down,ctrl-u:half-page-up"\
" --bind=alt-enter:select-all,alt-bs:deselect-all"\
" --bind=ctrl-o:preview'(echo {})'"\
" --height $FZF_TMUX_HEIGHT"\
" --history=$HOME/.fzf_history"
set -x FZF_DEFAULT_COMMAND fd --no-ignore --hidden --follow --exclude .git
# https://github.com/jethrokuan/fzf#commands
set -x FZF_FIND_FILE_COMMAND $FZF_DEFAULT_COMMAND

# https://github.com/pure-fish/pure
set -g pure_threshold_command_duration 2

################
# Key bindings #
################

if status --is-interactive
    # fzf-based fish functions https://github.com/jethrokuan/fzf
    set -q FZF_DISABLE_KEYBINDINGS; or set -U FZF_DISABLE_KEYBINDINGS 1
    bind \eo fzf_cd_up

    # fzy-based fish history search
    bind \co __fzf_find_file
    bind \cr fzy_history
    bind -M insert \cr fzy_history

    # quickfix-wrapped ripgrep call
    bind \er __rg_vim_qf

    # change key bindings while typing
    bind \cv toggle_key_bindings
    bind -M insert \cv toggle_key_bindings

    # Замена \cs который занят prefix'ом для tmux
    # bind -e --preset \cs
    # bind \cg pager-toggle-search

    # abbreviations
    abbr -a dc docker-compose
    abbr -a dig dig +short
    abbr -a do docker
    abbr -a ga git add
    abbr -a gc git commit
    abbr -a gco git checkout
    abbr -a gd git diff
    abbr -a gm git merge-base
    abbr -a gs git status
    abbr -a kc kubectl
    abbr -a l ls -a
    abbr -a psaux 'ps aux | head -1 && ps aux | grep -v grep | grep'
end

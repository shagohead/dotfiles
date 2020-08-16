if test -e "$__fish_config_dir/config.tokens.fish"
    source "$__fish_config_dir/config.tokens.fish"
end

# bat config
set -x BAT_PAGER never
set -x BAT_STYLE plain
set -x BAT_THEME base16

set -x DF_STATS "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}"
set -x EDITOR nvim

# fzf config
set -l _FZF_COLORS (string join "," "fg:7" "fg+:7" "bg:0" "bg+:0" "hl:6" "hl+:6" \
    "info:2" "prompt:1" "pointer:12" "marker:4" "spinner:11" "header:6")
set -x _FZF_COMMON_OPTS "--bind=ctrl-d:half-page-down,ctrl-u:half-page-up" \
    "--history=$HOME/.fzf_history --color=dark --color=$_FZF_COLORS"
# https://github.com/junegunn/fzf#environment-variables
set -x FZF_DEFAULT_OPTS "--reverse --height=$FZF_TMUX_HEIGHT $_FZF_COMMON_OPTS"
set -x FZF_DEFAULT_COMMAND "fd --no-ignore --hidden --follow --exclude .git"
# https://github.com/jethrokuan/fzf#commands
set -x FZF_FIND_FILE_COMMAND $FZF_DEFAULT_COMMAND
set -q FZF_TMUX; or set -U FZF_TMUX 1

set -x GOPATH $HOME/go
set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8
set -x PIPENV_VENV_IN_PROJECT 1
set -x PYENV_ROOT $HOME/.pyenv
set -x PYENV_SHELL fish
set -x PYTEST_ADDOPTS -x --ff --pdb --pdbcls=IPython.terminal.debugger:TerminalPdb
set -x PYTHONBREAKPOINT ipdb.set_trace

if test -e "$HOME/.pythonrc"
    set -x PYTHONSTARTUP "$HOME/.pythonrc"
end

# Директории для $PATH который будут добавлены в начало списка
set _PATH_PREPEND \
    /usr/local/opt/icu4c/bin \
    /usr/local/opt/gnu-getopt/bin \
    /usr/local/opt/gettext/bin \
    /usr/local/opt/ruby/bin \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    $GOPATH/bin \
    $HOME/.pyenv/shims

# В $PATH добавятся только существующие директории
for bin_path in $_PATH_PREPEND
    if test ! -d $bin_path
        set _PATH_PREPEND (string match -v $bin_path $_PATH_PREPEND)
    end
end

# Добавление в $PATH виртуального окружение Python
if test -n $VIRTUAL_ENV
    set _PATH_PREPEND $_PATH_PREPEND $VIRTUAL_ENV/bin
end

# Дополнение опций gcc установленными библиотеками
for opt_name in llvm zlib
    if test -d /usr/local/opt/$opt_name
        set -gx CPPFLAGS {$CPPFLAGS} -I/usr/local/opt/$opt_name/include
        set -gx LDFLAGS {$LDFLAGS} -L/usr/local/opt/$opt_name/lib

        if test "$opt_name" = "llmv"
            set -gx PKG_CONFIG_PATH /usr/local/opt/$opt_name/lib/pkgconfig
        else if test "$opt_name" = "zlib"
            set _PATH_PREPEND /usr/local/opt/$opt_name/bin $_PATH_PREPEND
        end
    end
end

set -x CFLAGS -I(xcrun --show-sdk-path)/usr/include/

# Дополнение $PATH значениями, переносимыми в начало списка, если уже имеется
for item in $_PATH_PREPEND # (re) prepend PATH
    set -gx PATH (string match -v $item $PATH)
    set -gx PATH $item $PATH
end

set -g pure_threshold_command_duration 2

abbr -a dc docker-compose
abbr -a dex docker exec -it
abbr -a dig dig +short
abbr -a do docker
abbr -a ga git add
abbr -a gc git commit
abbr -a gca git commit --amend
abbr -a gco git checkout
abbr -a gd git diff
abbr -a gs git status
abbr -a l ls -la
abbr -a psaux 'ps aux | head -1 && ps aux | grep -v grep | grep'
abbr -a run ./manage.py runserver
abbr -a tm tmux -u

alias dsa 'docker stop (docker ps -q)'
alias dps 'docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}"'
alias top 'top -o cpu'

if test -n "$ALACRITTY_LOG"
    set -x TERM alacritty
end

if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    alias base16-init 'source "$BASE16_SHELL/profile_helper.fish"'
    alias pyenv-init 'pyenv init - | source'

    # Colors:
    # black, red, green, yellow, blue, magenta, cyan, white
    # brblack, brred, brgreen, bryellow, brblue, brmagenta, brcyan, brwhite
    set fish_color_normal normal # the default color
    set fish_color_command blue # the color for commands
    set fish_color_quote green # the color for quoted blocks of text
    set fish_color_redirection brmagenta # the color for IO redirections
    set fish_color_end magenta # the color for process separators like ';' and '&'
    set fish_color_error red # the color used to highlight potential errors
    set fish_color_param normal # the color for regular command parameters
    set fish_color_comment brblack # the color used for code comments
    set fish_color_match --background=cyan # the color used to highlight matching parenthesis
    set fish_color_selection green # the color used when selecting text (in vi visual mode)
    set fish_color_search_match --background=brblack # used to highlight history search matches and the selected pager item (must be a background)
    set fish_color_operator magenta # the color for parameter expansion operators like '*' and '~'
    set fish_color_escape magenta # the color used to highlight character escapes like '\n' and '\x70'
    set fish_color_cwd brblue # the color used for the current working directory in the default prompt
    set fish_color_autosuggestion -d # the color used for autosuggestions
    set fish_color_user brcyan # the color used to print the current username in some of fish default prompts
    set fish_color_host brblue # the color used to print the current host system in some of fish default prompts
    set fish_color_cancel brred # the color for the '^C' indicator on a canceled command

    set fish_pager_color_prefix white --underline # the color of the prefix string, i.e. the string that is to be completed
    # set fish_pager_color_completion # the color of the completion itself
    set fish_pager_color_description bryellow # the color of the completion description
    set fish_pager_color_progress brcyan # the color of the progress bar at the bottom left corner
    # set fish_pager_color_secondary # the background color of the every second completion

    if test ! -e ~/.fzf_history
        touch ~/.fzf_history
    end

    if type -q register-python-argcomplete
        register-python-argcomplete --shell fish pipx | .
    end

    # TODO: remove current dir
    bind \ed fzf_cd_up

    bind \cr fzy_history
    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \cr fzy_history
    end

    bind \er __rg_vim_qf
end

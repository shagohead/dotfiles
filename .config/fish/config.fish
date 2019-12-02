if test -e "$__fish_config_dir/config.tokens.fish"
    source "$__fish_config_dir/config.tokens.fish"
end

set -x BAT_THEME 'base16'
set -x DF_STATS "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}"
set -x EDITOR nvim
set -x FZF_DEFAULT_COMMAND 'fd -i -H'
set -x GOPATH $HOME/go
set -x LANG ru_RU.UTF-8
set -x LC_CTYPE ru_RU.UTF-8
set -x PYTHONBREAKPOINT ipdb.set_trace
set -x PIPENV_VENV_IN_PROJECT 1
set -x PYENV_ROOT $HOME/.pyenv
set -x PYTEST_ADDOPTS -x --ff --pdb --pdbcls=IPython.terminal.debugger:TerminalPdb

# TODO: append only if there is no value like with _PATH_PREPEND
set -x CFLAGS {$CFLAGS} -I(xcrun --show-sdk-path)/usr/include/
set -x CPPFLAGS {$CPPFLAGS} -I/usr/local/opt/zlib/include
set -x LDFLAGS {$LDFLAGS} -L/usr/local/opt/zlib/lib
set -x PKG_CONFIG_PATH {$PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig

pyenv init - | source

set _PATH_PREPEND \
    /usr/local/opt/icu4c/bin \
    /usr/local/opt/gnu-getopt/bin \
    /usr/local/opt/gettext/bin \
    /usr/local/opt/ruby/bin \
    $HOME/Library/Python/3.7/bin \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    $HOME/.poetry/bin \
    $GOPATH/bin \
    $HOME/.pyenv/shims

if test -n $VIRTUAL_ENV # append virtual env /bin path
    set -gx _PATH_PREPEND $_PATH_PREPEND $VIRTUAL_ENV/bin
end

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
abbr -a tm tmux -u
abbr -a vim nvim
abbr -a run ./manage.py runserver

alias dsa 'docker stop (docker ps -q)'
alias dps 'docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}"'
alias ssh 'env TERM=xterm-256color ssh'
alias top 'top -o cpu'
alias tldr 'tldr -t ocean'

if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"

    if test \( "$POETRY_ACTIVE" = "1" \) -a \( -f .env \)
        posix_source # source .env on poetry shell activate
        if test -f .env.local
            posix_source .env.local
        end
    end

    function __set_tmux_window_title -a title
        tmux rename-window $title
        set -g tmux_window_title $title
    end

    function __fish_preexec_handler -e fish_preexec
        switch $argv
            case "./manage.py runserver*"
                __set_tmux_window_title "django-server"
            case "http-prompt*"
                __set_tmux_window_title "http-prompt"
            case "nvim *.tmux.conf"
                __set_tmux_window_title ".tmux.conf"
            case "nvim *.vimrc"
                __set_tmux_window_title ".vimrc"
        end
    end

    function __fish_postexec_handler -e fish_postexec
        set -q tmux_window_title
        if test $status -eq 0
            tmux rename-window "fish"
            set -e tmux_window_title
        end
    end

    if type -q register-python-argcomplete
        register-python-argcomplete --shell fish pipx | .
    end

    # starship init fish | source
end

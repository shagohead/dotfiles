if test -e .config.tokens.fish
    source .config.tokens.fish
end

set -x EDITOR nvim
set -x BROWSER safari

set -x LANG ru_RU.UTF-8
set -x LC_CTYPE ru_RU.UTF-8
set -x GOPATH $HOME/go
set -x LDFLAGS {$LDFLAGS} -L/usr/local/opt/zlib/lib
set -x CPPFLAGS {$CPPFLAGS} -I/usr/local/opt/zlib/include
set -x PKG_CONFIG_PATH {$PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig
set -x PYENV_ROOT $HOME/.pyenv

set -x PATH /usr/local/opt/icu4c/bin $PATH
set -x PATH /usr/local/opt/gnu-getopt/bin $PATH
set -x PATH /usr/local/opt/gettext/bin $PATH
set -x PATH /usr/local/opt/ruby/bin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.poetry/bin $PATH
set -x PATH $GOPATH/bin $PATH

abbr -a dc docker-compose
abbr -a dex docker exec -it
abbr -a dig dig +short
abbr -a ga git add
abbr -a gc git commit
abbr -a gca git commit --amend
abbr -a gco git checkout
abbr -a gd git diff
abbr -a gs git status
abbr -a l ls -la
abbr -a tm tmux -u
abbr -a run ./manage.py runserver

alias dsa 'docker stop (docker ps -q)'
alias dps 'docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}"'
alias top 'top -o cpu'

pyenv init - | source

if status --is-interactive
    function __set_tmux_window_title -a title
        tmux rename-window $title
        set -g tmux_window_title $title
    end

    function __fish_preexec_handler -e fish_preexec
        switch $argv
            case "./manage.py runserver*"
                __set_tmux_window_title "django-server"
            case "http-prompt*"
                __set_tmux_window_title "rest-client"
            case "nvim *.tmux.conf"
                __set_tmux_window_title "tmux.conf"
            case "nvim *.vimrc"
                __set_tmux_window_title "vimrc"
        end
    end

    function __fish_postexec_handler -e fish_postexec
        set -q tmux_window_title
        if test $status -eq 0
            tmux rename-window "fish"
            set -e tmux_window_title
        end
    end
end

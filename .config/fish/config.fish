set -x EDITOR nvim
set -x BROWSER safari

set -x LANG ru_RU.UTF-8
set -x LC_CTYPE ru_RU.UTF-8
set -x HOMEBREW_GITHUB_API_TOKEN ff1bc3fc4f864cc4b21c4d98be89d9ff433997ae
set -x DRONE_SERVER https://drone.yellow.jetstyle.ru
set -x DRONE_TOKEN Y491ebASfeo2jzFX56kopRc98SN5PVyH
set -x GOPATH /Users/lastdanmer/go
set -x LDFLAGS {$LDFLAGS} -L/usr/local/opt/zlib/lib
set -x CPPFLAGS {$CPPFLAGS} -I/usr/local/opt/zlib/include
set -x PKG_CONFIG_PATH {$PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig
set -x PYENV_ROOT $HOME/.pyenv

set -x PATH /usr/local/opt/icu4c/bin $PATH
set -x PATH /usr/local/opt/node@8/bin $PATH
set -x PATH /usr/local/opt/gnu-getopt/bin $PATH
set -x PATH /usr/local/opt/gettext/bin $PATH
set -x PATH /usr/local/opt/ruby/bin $PATH
set -x PATH /Users/lastdanmer/.local/bin $PATH
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

# environment depends executables
# TODO: move to pipx
alias http '/Users/lastdanmer/.pyenv/versions/http-prompt/bin/http'
alias flake8 '/Users/lastdanmer/.pyenv/versions/flake8/bin/flake8'
alias pylint '/Users/lastdanmer/.pyenv/versions/pylint/bin/pylint'
alias johnnydep '/Users/lastdanmer/.pyenv/versions/johnnydep/bin/johnnydep'
alias http-prompt '/Users/lastdanmer/.pyenv/versions/http-prompt/bin/http-prompt'
alias yapf '/Users/lastdanmer/.pyenv/versions/yapf/bin/yapf'

pyenv init - | source

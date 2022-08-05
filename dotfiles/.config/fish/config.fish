# Base16 cterm colors
set -l base00 '00'
set -l base01 '18'
set -l base02 '19'
set -l base03 '08'
set -l base04 '20'
set -l base05 '07'
set -l base06 '21'
set -l base07 '15'
set -l base08 '01'
set -l base09 '16'
set -l base0A '03'
set -l base0B '02'
set -l base0C '06'
set -l base0D '04'
set -l base0E '05'
set -l base0F '17'
# '09'='01' base08 - Bright Red
# '10'='02' base0B - Bright Green
# '11'='03' base0A - Bright Yellow
# '12'='04' base0D - Bright Blue
# '13'='05' base0E - Bright Magenta
# '14'='06' base0C - Bright Cyan

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
set -gx PATH $HOME/.local/bin $HOME/.cargo/bin $GOPATH/bin $HOME/.pyenv/shims $HOME/yandex-cloud/bin $PATH

################
# Tools config #
################

# check-list
set -q HOMEBREW_GITHUB_API_TOKEN; or echo 'set -xU HOMEBREW_GITHUB_API_TOKEN ...'

# https://support.apple.com/ru-ru/HT208050
set -x BASH_SILENCE_DEPRECATION_WARNING 1

# bat
set -x BAT_STYLE plain
set -x BAT_THEME base16-256

# FZF
set -Ux FZF_DEFAULT_OPTS \
" --color=bg+:$base01,bg:$base00,spinner:$base0C,hl:$base0D"\
" --color=fg:$base04,header:$base0D,info:$base0A,pointer:$base0C"\
" --color=marker:$base0C,fg+:$base06,prompt:$base0A,hl+:$base0D"\
" --bind=ctrl-d:half-page-down,ctrl-u:half-page-up"\
" --bind=alt-enter:select-all,alt-bs:deselect-all"\
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
    abbr -a gs tig status
    abbr -a kc kubectl
    abbr -a l ls -la
    abbr -a psaux 'ps aux | head -1 && ps aux | grep -v grep | grep'
end

if test -n "$ALACRITTY_LOG"
    # FIXME: Выглядит так будто она должна устанавливаться эмулятором терминала
    set -x TERM alacritty
end

set -x EDITOR vi
set -x VISUAL nvim
set -x LS_COLORS
set -x PAGER less -R
set -x MANPAGER less -R --use-color -Dd+b -Du+g

set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

# Python development
set -x PIPENV_VENV_IN_PROJECT 1
set -x PYENV_ROOT $HOME/.pyenv
set -x PYENV_SHELL fish
set -x PYTEST_ADDOPTS --reuse-db

# GO development
set -q GOPATH; or set -xU GOPATH $HOME/go

# PATH
if not set -q PATH_SET
    set -gx PATH $HOME/.local/bin $HOME/.cargo/bin $GOPATH/bin $HOME/.pyenv/shims $HOME/yandex-cloud/bin /usr/local/opt/curl/bin $PATH
    set -gx PATH_SET true
end

# Brew uses github tokens
set -q HOMEBREW_GITHUB_API_TOKEN; or echo 'set -xU HOMEBREW_GITHUB_API_TOKEN ...'

# https://support.apple.com/ru-ru/HT208050
set -x BASH_SILENCE_DEPRECATION_WARNING 1

set -x BAT_STYLE plain
set -x BAT_THEME ansi

if not set -q FZF_CONFIGURED
    set -Ux FZF_DEFAULT_COMMAND fd --no-ignore --hidden --follow --exclude .git
    set -Ux FZF_DEFAULT_OPTS \
    " --bind=ctrl-d:half-page-down,ctrl-u:half-page-up"\
    " --bind=alt-enter:select-all,alt-bs:deselect-all"\
    " --bind=ctrl-o:preview'(bat {})'"\
    " --history=$HOME/.fzf_history"
    # " --height $FZF_TMUX_HEIGHT"\
    # https://github.com/jethrokuan/fzf
    set -U FZF_DISABLE_KEYBINDINGS 1
    set -Ux FZF_FIND_FILE_COMMAND $FZF_DEFAULT_COMMAND
    set -U FZF_CONFIGURED true
end

set -x RIPGREP_CONFIG_PATH $HOME/.config/ripgrep

# https://jqlang.github.io/jq/manual/#colors
#----------------  null:falsetrue:num :str :arr :obj :obj-keys
set -xg JQ_COLORS "2;37:0;35:0;35:0;39:0;32:1;36:1;34:0;37"

# «Fix» tmux TERM_PROGRAM var overriding.
if [ "$TERM_PROGRAM" = "tmux" ]
    if [ -n "$KITTY_PID" ]
        set -gx TERM_PROGRAM kitty
        set -gu TERM_PROGRAM_VERSION
    end
end

if status --is-interactive
    set -x EDITOR $VISUAL

    bind \co __fzf_find_file
    # bind \cr fzy_history
    # bind -M insert \cr fzy_history

    # quickfix-wrapped ripgrep call
    bind \er rg_vim_qf

    # change key bindings while typing
    # bind \cv toggle_key_bindings
    # bind -M insert \cv toggle_key_bindings

    # abbreviations
    abbr -a dc docker compose
    abbr -a dig dig +short
    abbr -a d docker
    abbr -a ga git add
    abbr -a gc git commit
    abbr -a gco git checkout
    abbr -a gd git diff
    abbr -a gm git merge-base
    abbr -a gs git status
    abbr -a kc kubectl
    abbr -a l ls -a
    abbr -a psaux 'ps aux | head -1 && ps aux | grep -v grep | grep'
    abbr -a now date '+%y.%m.%d_%H:%M:%S'

    if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION enabled
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end
end

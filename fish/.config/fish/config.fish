#################
# Common config #
#################

if test -n "$ALACRITTY_LOG"
    set -x TERM alacritty
end

# editors
set -x EDITOR vi -e
set -x VISUAL nvim

# language
set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

# Python development
set -x PIPENV_VENV_IN_PROJECT 1
set -x PYENV_ROOT $HOME/.pyenv
set -x PYENV_SHELL fish
set -x PYTEST_ADDOPTS -x --ff --nf --reuse-db --pdb \
--pdbcls=IPython.terminal.debugger:TerminalPdb

# GO development
set -q GOPATH; or set -xU GOPATH $HOME/go

# PATH
set -gx PATH $HOME/.cargo/bin $GOPATH/bin $HOME/.pyenv/shims $PATH

################
# Tools config #
################

# check-list
set -q HOMEBREW_GITHUB_API_TOKEN; or echo 'set -xU HOMEBREW_GITHUB_API_TOKEN ...'

# https://support.apple.com/ru-ru/HT208050
set -x BASH_SILENCE_DEPRECATION_WARNING 1

# base16
set BASE16_SHELL $HOME/.config/base16-shell/

# bat
set -x BAT_STYLE plain

# fzf
set -l _fzf_colors fg:7,fg+:7,bg:0,bg+:0,hl:6,hl+:6,\
info:2,prompt:1,pointer:12,marker:4,spinner:11,header:6
# FIXME: add preview-window=up supported by vim
set -l _fzf_common_opts --bind=ctrl-d:half-page-down,ctrl-u:half-page-up \
--history=$HOME/.fzf_history --color=dark --color=$_fzf_colors
set -x FZF_DEFAULT_OPTS --reverse --height=$FZF_TMUX_HEIGHT $_fzf_common_opts
set -l _fzf_bind_select --bind=alt-enter:select-all,alt-bs:deselect-all
set -x FZF_NVIM_OPTS (string join -- ' ' $_fzf_common_opts $_fzf_bind_select)
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

    # complete from tmux buffer
    bind \cx 'commandline -i (fzf-complete-from-tmux.sh) 2>/dev/null'

    # change key bindings while typing
    bind \cv toggle_key_bindings
    bind -M insert \cv toggle_key_bindings

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
    abbr -a l ls -la
    abbr -a psaux 'ps aux | head -1 && ps aux | grep -v grep | grep'

    # set light or dark background style
    set -l DARK_SHELL 0
    if test (uname -s) = Darwin
        set DARK_SHELL (defaults read -globalDomain AppleInterfaceStyle &> /dev/null; echo $status)
    end

    # set style themes
    set -gx BAT_THEME TwoDark
    set -gx BASE16_THEME base16-onedark
    if test $DARK_SHELL -ne 0
        set BAT_THEME base16-256
        set BASE16_THEME base16-one-light
    end

    # apply shell theme
    sh $BASE16_SHELL/scripts/$BASE16_THEME.sh

    # update ~/.vim_background
    echo -e "if !exists('g:colors_name') || g:colors_name != '\
$BASE16_THEME'\n  colorscheme $BASE16_THEME\nendif" > ~/.vimrc_background
end

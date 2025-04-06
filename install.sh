#!/bin/bash

set -e

title() {
  echo -e "$(tput bold)$@$(tput sgr0)"
}

main() {
  if ! which -s brew; then
    title "Установка Homebrew"
    sudo -v
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  title "Установка библиотек и приложений из Homebrew"
  brew bundle

  fish -c 'set -q HOMEBREW_GITHUB_API_TOKEN; or set -xU HOMEBREW_GITHUB_API_TOKEN (read -P "Github API token for Homebrew: ")'

  CONFIG=$XDG_CONFIG_HOME
  if [ -z "$CONFIG" ]; then
    CONFIG=$HOME/.config
  fi

  stow --no-folding -t ~/ dotfiles

  title "Клонирование/актуализация cterm256-contrib"
  if [ -d $CONFIG/cterm256-contrib ]; then
    git -C $CONFIG/cterm256-contrib pull
  else
    git clone github.com:shagohead/cterm256-contrib $CONFIG/cterm256-contrib
  fi
  for name in delta tig; do
    if !(git config get --global --all include.path | grep -q $name/.gitconfig); then
      git config set --global --append include.path $CONFIG/cterm256-contrib/$name/.gitconfig
    fi
  done

  if ! [ -f $CONFIG/nvim/colors/cterm256.vim ]; then
    ln -s $CONFIG/cterm256-contrib/vim/cterm256.vim $CONFIG/nvim/colors
  fi

  found=0
  for fconf in $CONFIG/tmux/tmux.conf ~/.tmux.conf; do
    if [ -f $fconf ]; then
      fpath=$fconf
      if grep -q cterm256-contrib/tmux/.tmux.conf $fconf; then
        found=1
        break
      fi
    fi
  done

  if [ $found == 0 ]; then
    echo "source-file $CONFIG/cterm256-contrib/tmux/.tmux.conf" >>$fpath
  fi

  declare -a GO_PACKAGES=(
    github.com/go-delve/delve/cmd/dlv
    github.com/josharian/impl
    github.com/shagohead/cterm256/cmd/cterm256
    golang.org/x/tools/gopls
  )
  title "Сборка и установка утилит на Go"
  for i in "${GO_PACKAGES[@]}"; do
    go install "${i}@latest"
  done

  title "Установка и обновление плагинов для neovim"
  nvim --headless +"Lazy install" +qall

  title "Установка и обновление LSP серверов для neovim"
  declare -a LSP_SERVERS=(
    bash-language-server
    clangd
    dockerfile-language-server
    gopls
    lua-language-server
    pyright
    typescript-language-server
    vim-language-server
    yaml-language-server
  )
  nvim --headless +"MasonInstall ${LSP_SERVERS[@]}" +qall

  if ! fish -c "type -q fisher"; then
    title "Установка менеджера плагинов для fish"
    curl https://git.io/fisher --create-dirs -sLo $CONFIG/fish/functions/fisher.fish
  fi

  title "Установка и обновление плагинов для fish"
  fish -c "fisher update"

  # if ! witch -s rustup; then
  #   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  #   rustup completions fish > $CONFIG/fish/completions/rustup.fish
  # fi
}

main "$@"

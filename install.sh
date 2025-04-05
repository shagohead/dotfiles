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
  CONFIG=$XDG_CONFIG_HOME
  if [ -z "$CONFIG" ]; then
    CONFIG=$HOME/.config
  fi
  [ ! -d "$CONFIG" ] && mkdir "$CONFIG"
  [ ! -d "$CONFIG/fish/conf.d" ] && mkdir $CONFIG/fish/conf.d
  [ ! -d "$CONFIG/fish/completions" ] && mkdir $CONFIG/fish/completions
  stow dotfiles

  declare -a GO_PACKAGES=(
    github.com/go-delve/delve/cmd/dlv
    github.com/kyleconroy/sqlc/cmd/sqlc
    github.com/josharian/impl
    github.com/shagohead/cterm256/cmd/cterm256
    golang.org/x/tools/gopls
    google.golang.org/protobuf/cmd/protoc-gen-go
  )
  title "Сборка и установка утилит на Go"
  for i in "${GO_PACKAGES[@]}"; do
    go install "${i}@latest"
  done

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

  title "Клонирование/актуализация cterm256-contrib"
  if [ -d $CONFIG/cterm256-contrib ]; then
    git -C $CONFIG/cterm256-contrib pull
  else
    git clone github.com:shagohead/cterm256-contrib $CONFIG/cterm256-contrib
  fi

  # if ! witch -s rustup; then
  #   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  #   rustup completions fish > $CONFIG/fish/completions/rustup.fish
  # fi
}

main "$@"

#!/bin/bash

set -e

title() {
  echo -e "$(tput bold)$@$(tput sgr0)"
}

main() {
  setgitopt "user.name"
  setgitopt "user.email"

  if ! which -s brew; then
    title "Установка Homebrew"
    sudo -v
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew_path=/usr/local
    if [ "$(uname -p)" == "arm" ]; then
      brew_path=/opt/homebrew
    fi
    eval "$($brew_path/bin/brew shellenv)"
  fi

  fish -c 'set -q HOMEBREW_GITHUB_API_TOKEN; or set -xU HOMEBREW_GITHUB_API_TOKEN (read -P "Github API токен для Homebrew: ")'

  title "Установка библиотек и приложений из Homebrew"
  brew bundle

  CONFIG=$XDG_CONFIG_HOME
  if [ -z "$CONFIG" ]; then
    CONFIG=$HOME/.config
  fi

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

  title "Создание ссылок на конфигурационные файлы"
  stow --no-folding -t ~/ dotfiles

  title "Установка fish в качестве стандартного shell'а"
  fish_cmd=$(which fish)
  if ! grep -q "$fish_cmd" /etc/shells; then
    sudo echo "$fish_cmd" >>/etc/shells
  fi
  if [ "$(dscl . -read ~/ UserShell | sed 's/UserShell: //')" != "$fish_cmd" ]; then
    sudo chsh -s "$fish_cmd" $USER
  fi

  kitty_conf=$CONFIG/kitty/kitty.conf
  if ! (grep -q "include custom.conf" $kitty_conf 2>/dev/null); then
    printf "include custom.conf\nshell $fish_cmd" >>$kitty_conf
  fi

  if ! [ -f $CONFIG/nvim/colors/cterm256.vim ]; then
    ln -s $CONFIG/cterm256-contrib/vim/cterm256.vim $CONFIG/nvim/colors
  fi

  tmux_shared_found=0
  tmux_cterm_found=0
  tmux_conf=$CONFIG/tmux/tmux.conf
  for fconf in $CONFIG/tmux/tmux.conf ~/.tmux.conf; do
    if [ -f $fconf ]; then
      tmux_conf=$fconf
      if grep -q $CONFIG/tmux/tmux.shared.conf $fconf; then
        tmux_shared_found=1
      fi
      if grep -q cterm256-contrib/tmux/.tmux.conf $fconf; then
        tmux_cterm_found=1
      fi
    fi
  done
  if [ $tmux_shared_found == 0 ]; then
    echo "source-file $CONFIG/tmux/tmux.shared.conf" >>$tmux_conf
  fi
  if [ $tmux_cterm_found == 0 ]; then
    echo "source-file $CONFIG/cterm256-contrib/tmux/.tmux.conf" >>$tmux_conf
  fi

  declare -a GO_PACKAGES=(
    github.com/go-delve/delve/cmd/dlv
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
  nvim --headless +"MasonInstall --force ${LSP_SERVERS[@]}" +qall

  if ! fish -c "type -q fisher"; then
    title "Установка менеджера плагинов для fish"
    curl https://git.io/fisher --create-dirs -sLo $CONFIG/fish/functions/fisher.fish
  fi

  title "Установка и обновление плагинов для fish"
  fish -c "fisher update"

  if ! [ -f $CONFIG/fish/themes/cterm256.theme ]; then
    ln -s $CONFIG/cterm256-contrib/fish/cterm256.theme $CONFIG/fish/themes
  fi
  fish -c "fish_config theme choose cterm256"
  fish -c "echo y | fish_config theme save"

  k9s_conf=$HOME/Library/Application\ Support/k9s
  if ! [ -f $k9s_conf/skins/cterm256.yaml ]; then
    if ! [ -d $k9s_conf/skins ]; then
      mkdir -p $k9s_conf/skins
    fi
    ln -s $CONFIG/cterm256-contrib/k9s/cterm256.yaml $k9s_conf/skins
  fi

  # if ! witch -s rustup; then
  #   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  #   rustup completions fish > $CONFIG/fish/completions/rustup.fish
  # fi
}

setgitopt() {
  if ! git config get --global $1 1>/dev/null; then
    read -p "Значение для git --global $1: " value
    if [[ -z "$value" ]]; then
      echo "Значение $1 не задано. Пропуск"
      return
    fi
    git config set --global $1 $value
  fi
}

main "$@"

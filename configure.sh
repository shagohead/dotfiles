#!/bin/bash

set -e

title () {
  echo -e "$(tput bold)$@$(tput sgr0)"
}

main() {
  if ! grep -q /usr/local/bin/fish /etc/shells; then
    title "Установка fish как shell по-умолчанию"
    sudo echo "/usr/local/bin/fish" >> /etc/shells
    sudo chsh -s /usr/local/bin/fish
  fi

  setgitopt "user.name"
  setgitopt "user.email"

  KITTY_CONF="$HOME/.config/kitty/kitty.conf"
  if [ -f $KITTY_CONF ]; then
    title "Дополнение kitty.conf"
    if ! grep -q "include custom.conf" $KITTY_CONF; then
      echo "include custom.conf" >> $KITTY_CONF
    fi
  fi

  title "Назначение цветов в fish"
  FISH_CONFIG_COMMAND="
  set fish_color_normal normal
  set fish_color_command blue
  set fish_color_param normal
  set fish_color_quote green
  set fish_color_redirection brmagenta
  set fish_color_error red
  set fish_color_end magenta
  set fish_color_comment brblack
  set fish_color_operator magenta
  set fish_color_option --bold
  set fish_color_escape magenta
  set fish_color_cancel brred
  set fish_color_status red
  set fish_color_keyword cyan
  set fish_color_user brcyan
  set fish_color_cwd brblue
  set fish_color_cwd_root brred
  set fish_color_host brblue
  set fish_color_host_remote yellow
  set fish_color_valid_path --underline
  set fish_color_selection bryellow --bold --background=brblack
  set fish_color_match --background=cyan
  set fish_color_search_match --background=brblack
  set fish_color_autosuggestion -d
  set fish_color_history_current --bold


  set fish_pager_color_prefix white --underline
  set fish_pager_color_description bryellow
  set fish_pager_color_progress brcyan"
  fish -c "$FISH_CONFIG_COMMAND"
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

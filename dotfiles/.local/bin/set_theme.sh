#!/bin/bash
set -e

usage() {
  echo "usage: set_theme.sh <theme>"
  echo
  echo "Themes are: light / dark."
  echo "Example: set_theme.sh dark"
  echo
  echo "Then script does next things:"
  echo " - search for theme name in appropriate env var (\$THEME_LIGHT) or file (~/.config/kitty/theme_light)"
  echo " - set theme for next kitty launches, and if its running already - updates current config"
  echo " - set desktop wallpaper from appropriate env var (\$WALLPAPER_LIGHT), if it exists."
}

main() {
  if [ $# -lt 1 ]; then
    usage
    exit 1
  fi

  case $1 in
    "light" | "dark")
      var_suffix=$(echo $1 | awk '{print toupper($0)}')
      ;;

    *)
      echo "Theme $1 unsupported!";
      exit 1
      ;;
  esac

  name_var="THEME_$var_suffix"
  name=${!name_var}
  if [ -n "$name" ]; then
    echo "Found theme name $name in variable $name_var"
  else
    name_file=~/.config/kitty/theme_$1
    if [ -f "$name_file" ]; then
      name=$(cat $name_file | tr -d '\n')
      if [ -z "$name" ]; then
        echo "Found file $name_file, but it is empty"
        exit 1
      fi
    else
      echo "Neither var $name_var nor file $name_file was found"
      exit 1
    fi
  fi

  theme=~/.config/kitty/themes/$name.conf
  cp $theme ~/.config/kitty/current-theme.conf
  pidfile=$(find /tmp/mykitty* 2>/dev/null)
  if [ -n "$pidfile" ]; then
    kitty @ --to "unix:$pidfile" set-colors -a -c $theme
  fi
}

main "$@"

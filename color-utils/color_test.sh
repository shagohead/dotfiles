#!/bin/bash
# This script renders color table like on these chart:
# https://en.wikipedia.org/wiki/File:Xterm_256color_chart.svg

start=16
height=6
cols=(0 1 2 3 4 5 11 10 9 8 7 6)

render()
{
  for h in $@; do
    for fg in 30 37; do
      for col in ${cols[@]}; do
        color=$((col*height+h))
        printf "\e[${fg};48;5;%sm  %3s  \e[0m" $color $color
      done
      echo
    done
  done
  echo
}


render {16..21}
render {93..88}
render {160..165}

range()
{
  for fg in 30 37; do
    for color in $@; do
      printf "\e[${fg};48;5;%sm  %3s  \e[0m" $color $color
    done
    echo
  done
}
range {232..243}
range {255..244}
echo
range {0..7}
range {8..15}

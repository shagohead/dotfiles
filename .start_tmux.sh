#!/bin/sh

if [ -f ~/.base16_theme ]; then
    source ~/.base16_theme
fi

tmux -u a || tmux -u

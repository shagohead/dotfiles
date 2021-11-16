#!/bin/sh

if [ -f ~/.base16_theme ]; then
    source ~/.base16_theme
fi

tmux -u attach || tmux -u new-session -s '~'

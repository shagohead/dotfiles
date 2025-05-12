function ctheme -d "cterm256'based theme changer"
    set p ~/src/github.com/kovidgoyal/kitty-themes/themes
    set fp $p/(ls $p | fzf --preview "cterm256 -f $p/{} -print"); or return
    cterm256 --light-stderr -f $fp 1>/dev/null 2>|read bg
    cterm256 -f $fp > ~/.config/kitty/$bg-theme.auto.conf
    kitty @ set-colors --to "$KITTY_LISTEN_ON" -a ~/.config/kitty/$bg-theme.auto.conf
end

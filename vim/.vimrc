if !empty(glob("~/.config/nvim/"))
    set runtimepath^=~/.config/nvim/

    if !empty(glob("~/.config/nvim/after/"))
        set runtimepath+=~/.config/nvim/after/
    endif

    if filereadable(glob("~/.config/nvim/init.vim"))
        source ~/.config/nvim/init.vim
    endif
endif

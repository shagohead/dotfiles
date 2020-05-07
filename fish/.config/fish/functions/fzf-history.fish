function fzf-history
    history | fzf | read -l foo
    and commandline -- $foo
    commandline -f repaint
end

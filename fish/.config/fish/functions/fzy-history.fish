function fzy-history
    history | fzy | read -l foo
    and commandline -- $foo
    commandline -f repaint
end


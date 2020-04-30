function fzy-history
    history | fzy | read -l foo
    commandline -f repaint
    commandline $foo
end


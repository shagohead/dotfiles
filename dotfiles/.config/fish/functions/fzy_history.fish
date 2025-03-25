function fzy_history -d "FZY search through command history"
    history | fzy | read -l foo
    and commandline -- $foo
    commandline -f repaint
end

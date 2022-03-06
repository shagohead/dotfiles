function fzf_history -d "FZF search through command history"
    history | fzf | read -l foo
    and commandline -- $foo
    commandline -f repaint
end

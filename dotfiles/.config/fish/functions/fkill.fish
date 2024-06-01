function fkill -d "Fuzzy-finded kill"
    set pid (ps -ef | sed 1d | fzf -m --preview='echo {}' --preview-window=down:wrap | awk '{print $2}')

    if test -n "$pid"
        echo $pid | xargs kill -9
    end
end

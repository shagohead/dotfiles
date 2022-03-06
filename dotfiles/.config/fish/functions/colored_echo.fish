function colored_echo
    set_color $argv[1]
    echo -n $argv[2]
    set_color normal
    echo ""
end

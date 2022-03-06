function error_echo
    set_color red
    echo -n $argv 1>&2
    set_color normal
    echo "" 1>&2
end

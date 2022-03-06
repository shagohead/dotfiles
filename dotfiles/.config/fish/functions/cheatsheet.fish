function cheatsheet
    set --local argv $argv

    if test -z $argv
        set argv '-h'
    end

    if test $argv = '-h'
        colored_echo yellow "ﬤ cheatsheet tools:"
        echo "cheat, eg, tldr"
        echo

        colored_echo yellow " insert character by number:"
        echo ":help i_CTRL-V_digit (tip: u/U for unicode)"
        echo

        colored_echo yellow " insert digraph character:"
        echo ":help i_CTRL-K char char"
    end
    
    if test $argv = '-c'
        echo \
        'PYCURL_SSL_LIBRARY=openssl LDFLAGS="-L/usr/local/opt/openssl/lib" CPPFLAGS="-I/usr/local/opt/openssl/include" pip install --no-cache-dir pycurl' \
        | fzf | read -l foo
        and commandline -- $foo
        commandline -f repaint
    end
end

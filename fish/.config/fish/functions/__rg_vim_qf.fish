function __rg_vim_qf -d "Wraps current rg command to populate nvim ($EDITOR) quickfix list"
    set -l cmd vim
    if set -q EDITOR; and string match -r '.?vim' $EDITOR 1>/dev/null
        echo $EDITOR | read -at cmd
    end

    if test -z (commandline -j | string join '')
        commandline -a $history[1]
    end

    if commandline -j | string match -q -r -v -- '--vimgrep'
        commandline -aj -- ' --vimgrep'
    end

    if commandline -j | string match -q -r -v -- 'psub'
        commandline -aj -- ' | psub'
    end

    if commandline -j | string match -q -r -v -- "$cmd .*\$"
        set -l job (commandline -j)
        commandline -rj -- "nvim -q ($job)"
    end
end

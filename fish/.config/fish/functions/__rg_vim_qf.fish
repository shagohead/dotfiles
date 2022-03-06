function __rg_vim_qf -d "Обрамляет текущий вызов rg для передачи его в nvim ($EDITOR) список quickfix"
    set -l cmd vim
    if set -q VISUAL; and string match -r '.?vim' $VISUAL 1>/dev/null
        echo $VISUAL | read -at cmd
    end

    if test -z (commandline -j | string join '')
        commandline -a $history[1]
    end

    if commandline -j | string match -q -r -v -- '--vimgrep'
        commandline -aj -- ' --vimgrep'
    end

    if commandline -j | string match -q -r -v -- '--sort'
        commandline -aj -- ' --sort path'
    end

    if commandline -j | string match -q -r -v -- 'psub'
        commandline -aj -- ' | psub'
    end

    if commandline -j | string match -q -r -v -- "$cmd .*\$"
        set -l job (commandline -j)
        commandline -rj -- "nvim -q ($job) +copen"
    end
end

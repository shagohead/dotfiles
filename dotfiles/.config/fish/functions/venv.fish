function venv \
    --description "Activate python virtualenv & export environment variables" \
    --argument-names action

    if test -z "$action"
        set action "spawn"
    end

    set -l activate_script

    for dir in .venv venv
        if test -e $dir/bin/activate.fish
            set activate_script $dir/bin/activate.fish
            break
        end
    end

    if test -z $activate_script
        echo "activate.fish not found, venv not activated"
        return 1
    end

    switch $action
    case "spawn"
        echo 'Starting sub-shell..'
        fish -C 'venv activate'
    case "activate"
        source $activate_script
        for path in .env .env.local
            if test -e $path
                posix_source $path
            end
        end
        if test -e (echo $VIRTUAL_ENV/lib/python*/site-packages)/ipdb
            set -gx PYTHONBREAKPOINT ipdb.set_trace
        end
    case "*"
        echo "Unknown provided action"
        return 1
    end
end

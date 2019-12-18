function venv --description 'Activate python virtualenv & export environment variables'
    function colored_echo
        set_color $argv[1]
        echo -n $argv[2]
        set_color normal
        echo ""
    end

    set -l activate_script
    set -l venv_dirs .venv venv
    set -l env_files .env .env.local

    for dir in $venv_dirs
        if test -e $dir/bin/activate.fish
            set activate_script $dir/bin/activate.fish
            break
        end
    end

    if test -z $activate_script
        colored_echo yellow "activate.fish not found, venv not activated"
        return
    end

    source $activate_script
    for path in $env_files
        if test -e $path
            posix_source $path
        end
    end

    functions -e colored_echo
end

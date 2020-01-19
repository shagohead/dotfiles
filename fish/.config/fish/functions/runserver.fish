function runserver --description 'Run development server'
    set -l arguments
    set -l has_exec 0

    if test -f ./pyproject.toml
        set arguments $arguments poetry run
    end

    if test -f ./manage.py
        set has_exec 1
        set arguments $arguments python manage.py runserver
    end

    for arg in $argv
        set has_exec 1
        set arguments $arguments $arg
    end

    if test $has_exec -eq 0
        set_color red
        echo "Executable not found"
        set_color normal
        return
    else
        eval $arguments
    end
end

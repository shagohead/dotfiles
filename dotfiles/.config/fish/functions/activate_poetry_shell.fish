function activate_poetry_shell
    source (dirname (poetry run which python))/activate.fish
    if test -e .env
        posix_source
    end
end

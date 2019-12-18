# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.FaGIhJ/poetry_shell.fish @ line 2
function activate_poetry_shell
	source (dirname (poetry run which python))/activate.fish
    if test -e .env
        posix_source
    end
end

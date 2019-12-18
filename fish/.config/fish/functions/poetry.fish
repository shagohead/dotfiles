function __poetry_shell_activate --on-variable PWD
    if status --is-command-substitution
		return
	end

    # TODO
	if test -e "$PWD/poetry.lock"
        # echo "exists!"
    end
end

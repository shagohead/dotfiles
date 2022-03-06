function ipdb -d "Invoke ipdb class into env variables"
    # Удаление класса дебагера из PYTEST_ADDOPTS
    if set -q PYTEST_ADDOPTS
        for i in (seq (count $PYTEST_ADDOPTS))
            if string match -q -- '--pdbcls*' $PYTEST_ADDOPTS[$i]
                set -e PYTEST_ADDOPTS[$i]
            end
        end

        # И установка для него нового значения
        set -p PYTEST_ADDOPTS --pdbcls=IPython.terminal.debugger:TerminalPdb
    end

    set -x PYTHONBREAKPOINT ipdb.set_trace
    eval $argv
end

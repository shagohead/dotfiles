function pdb -d "Invoke builtin pdb into env variables"
    # Удаление класса дебагера из PYTEST_ADDOPTS
    if set -q PYTEST_ADDOPTS
        for i in (seq (count $PYTEST_ADDOPTS))
            if string match -q -- '--pdbcls*' $PYTEST_ADDOPTS[$i]
                set -e PYTEST_ADDOPTS[$i]
            end
        end
    end

    set -x PYTHONBREAKPOINT pdb.set_trace
    eval $argv
end

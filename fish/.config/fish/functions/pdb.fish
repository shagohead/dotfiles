function pdb -d "invoke builtin pdb into env variables"
    set -x PYTHONBREAKPOINT pdb.set_trace
    for i in (seq (count $PYTEST_ADDOPTS))
        if string match -q -- '--pdbcls*' $PYTEST_ADDOPTS[$i]
            set -e PYTEST_ADDOPTS[$i]
        end
    end
    eval $argv
end

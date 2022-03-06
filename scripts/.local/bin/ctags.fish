#!/usr/bin/env fish

# fd -e py
# set site_packages

# if test -e poetry.lock
#     set site_packages (poetry run python -c 'import sys; print(sys.path[-1])')
# end

# if test -e Pipfile.lock
#     set python (pipenv --py 2> /dev/null)
#     if test -n $python
#         set site_packages (fish -c $python' -c "import sys; print(sys.path[-1])"')
#     end
# end

# if test -z "$site_packages" -a -f .venv/bin/python
#     set site_packages (fish -c '.venv/bin/python -c "import sys; print(sys.path[-1])"')
# end

# if test -n $site_packages
#     fd -E 'jedi/' -E 'mypy*' '.py$' $site_packages
# end

fd -E 'jedi/' -E 'mypy*' -e py -I -H

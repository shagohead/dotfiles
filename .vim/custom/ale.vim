let g:ale_echo_msg_info_str = 'I'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %code: %%s'

let g:ale_list_window_size = 4
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0

let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0
let g:ale_sign_error = '‼'
let g:ale_sign_warning = '∙'

" let g:ale_go_go_executable = 'GOPATH="$(pwd):$GOPATH" go'
" let g:ale_go_go_executable = 'go'
let g:ale_go_golint_executable = '/Users/lastdanmer/go/bin/golint'

let g:ale_python_flake8_executable = '/Users/lastdanmer/.pyenv/versions/flake8/bin/flake8'
let g:ale_python_flake8_options = '--ignore=E129,E501,E302,E265,E241,E305,E402,W503'
let g:ale_python_mypy_executable = '/Users/lastdanmer/.pyenv/versions/mypy/bin/mypy'
let g:ale_python_pylint_executable = '/Users/lastdanmer/.pyenv/versions/pylint/bin/pylint'
let g:ale_python_pylint_options = '--rcfile=~/.pylintrc --load-plugins=pylint_django'

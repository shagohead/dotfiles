map <C-m> :ALENext<CR>

nmap <Leader>al :ALELint<CR>
nmap <Leader>ai :ALEInfo<CR>
nmap <Leader>ad :ALEDetail<CR>
nmap <Leader>af :ALEFix<CR>
nmap <Leader>an :ALENext<CR>
nmap <Leader>ap :ALEPrevious<CR>
nmap <Leader>ar :ALEResetBuffer<CR>

let g:ale_echo_msg_info_str = 'I'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %code: %%s'
let g:ale_list_window_size = 4
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0
let g:ale_sign_error = '‼'
let g:ale_sign_warning = '∙'
let g:ale_python_flake8_executable = '/Users/lastdanmer/.pyenv/versions/flake8/bin/flake8'
let g:ale_python_flake8_options = '--ignore=E129,E501,E302,E265,E241,E305,E402,W503'
let g:ale_python_mypy_executable = '/Users/lastdanmer/.pyenv/versions/mypy/bin/mypy'
let g:ale_python_pylint_executable = '/Users/lastdanmer/.pyenv/versions/pylint/bin/pylint'
let g:ale_python_pylint_options = '--rcfile=~/.pylintrc --load-plugins=pylint_django'
let g:ale_python_pylint_options = '--rcfile=~/.pylintrc'

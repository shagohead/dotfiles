set tabstop=2
set shiftwidth=2

let b:ale_linters = ['eslint', 'standard']
let b:ale_fixers = ['eslint', 'standard']
let b:ale_javascript_xo_options = '--space --global=$'
let b:ale_javascript_standard_options = '--global $ --global WebSocket'

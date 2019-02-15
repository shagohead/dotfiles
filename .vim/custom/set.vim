set nu
set mouse=a
set undofile
set cursorline
set splitbelow
set splitright
set noswapfile
set foldcolumn=1
set timeoutlen=2000
set tags=./.ctags,.ctags

set hlsearch
set incsearch
set smartcase
set ignorecase

set autoindent

let g:python_host_prog  = '/usr/local/Cellar/python@2/2.7.15_1/bin/python'
let g:python3_host_prog = '/usr/local/Cellar/python/3.7.2_1/bin/python'

"let g:session_autosave = 'yes'
"let g:session_autoload = 'yes'
"let g:session_default_to_last = 1

let g:airline#extensions#ale#enabled = 1

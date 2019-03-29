syntax enable
colorscheme dracula
set encoding=utf-8
filetype plugin indent on
highlight CursorLine ctermbg=NONE guibg=#303241

source ~/.vim/custom/pre_plug.vim
call plug#begin('~/.local/share/nvim/plugged')

" File types
Plug 'dag/vim-fish'
Plug 'chr4/nginx.vim'
Plug 'pangloss/vim-javascript'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'jeetsukumaran/vim-pythonsense'

" Formatting
Plug 'godlygeek/tabular'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'

" Other
Plug 'w0rp/ale'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'

" With custom options
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

call plug#end()

if !has('nvim')
    set t_Co=256
    set guicursor+=a:blinkon0
    "set mouse=nicr

    let &t_SI.="\e[5 q" " insert
    let &t_SR.="\e[4 q" " replace
    let &t_EI.="\e[1 q" " normal
endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" augroup AutoSaveFolds
"   autocmd!
"   autocmd BufWinLeave *.* mkview
"   autocmd BufWinEnter *.* silent! loadview
" augroup END

source ~/.vim/custom/abbr.vim
source ~/.vim/custom/cmd.vim
source ~/.vim/custom/map.vim
source ~/.vim/custom/set.vim

source ~/.vim/custom/ale.vim
source ~/.vim/custom/coc.vim
source ~/.vim/custom/ctrlp.vim
source ~/.vim/custom/fzf.vim

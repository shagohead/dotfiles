syntax enable
colorscheme dracula
set encoding=utf-8
filetype plugin indent on
highlight CursorLine ctermbg=NONE guibg=#303241

source ~/.vim/custom/pre_plug.vim
call plug#begin('~/.local/share/nvim/plugged')

Plug 'w0rp/ale'
Plug 'chr4/nginx.vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'godlygeek/tabular'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'wellle/targets.vim'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'jeetsukumaran/vim-pythonsense'

Plug 'dracula/vim',             {'as': 'dracula'}
Plug 'Valloric/YouCompleteMe',  {'do': function('BuildYCM')}

"Plug 'davidhalter/jedi-vim'
"Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
"Plug 'zchee/deoplete-jedi'

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

augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview
augroup END

command! CopyPath let @+ = expand('%:p')
command! Delallmarks delmarks A-Z0-9\"[]

source ~/.vim/custom/abbr.vim
source ~/.vim/custom/map.vim
source ~/.vim/custom/set.vim

source ~/.vim/custom/ale.vim
source ~/.vim/custom/ctrlp.vim
source ~/.vim/custom/fzf.vim
source ~/.vim/custom/ycm.vim

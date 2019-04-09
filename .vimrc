syntax enable
set encoding=utf-8
colorscheme dracula
filetype plugin indent on
highlight CursorLine ctermbg=NONE guibg=#303241

call plug#begin('~/.local/share/nvim/plugged')

" File types
Plug 'dag/vim-fish'
Plug 'chr4/nginx.vim'
Plug 'pangloss/vim-javascript'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'HerringtonDarkholme/yats.vim'

" Formatting
Plug 'godlygeek/tabular'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'

" Other
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'

" With custom options
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

" Icons
Plug 'ryanoasis/vim-devicons'

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

" Variables
let g:airline_powerline_fonts = 1
" TODO: autorefresh and show / hide if there exists messages or not
" let g:airline_skip_empty_sections = 1
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
let g:webdevicons_enable_ctrlp = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

let g:python_host_prog  = '/usr/local/Cellar/python@2/2.7.15_1/bin/python'
let g:python3_host_prog = '/usr/local/Cellar/python/3.7.2_1/bin/python'
let g:coc_node_path = '/Users/lastdanmer/.config/nvm/11.13.0/bin/node'

" Autocommands
au BufNewFile,BufRead flake8 setf dosini

" Abbreviations
iab {{ {{ }}<Left><Left><Left>
inorea <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)

" Commands
command! DirFiles Files %:h
command! CopyPath let @+ = expand('%:p')
command! Delallmarks delmarks A-Z0-9\"[]
command! -nargs=0 Format :call CocAction('format')
command! -range FormatSQL <line1>,<line2>!sqlformat --reindent --keywords upper --identifiers lower -

source ~/.vim/custom/ctrlp.vim
source ~/.vim/custom/fzf.vim
source ~/.vim/custom/mappings.vim
source ~/.vim/custom/settings.vim

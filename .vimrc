syntax enable
filetype plugin indent on

" Plugins {{{

call plug#begin('~/.local/share/nvim/plugged')

" File types
Plug 'dag/vim-fish'
Plug 'chr4/nginx.vim'
Plug 'cespare/vim-toml'
Plug 'pangloss/vim-javascript'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'Vimjas/vim-python-pep8-indent'
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
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/limelight.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'michaeljsmith/vim-indent-object'
Plug 'junegunn/rainbow_parentheses.vim'

" With custom options
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

" Icons
Plug 'ryanoasis/vim-devicons'

call plug#end()

source ~/.vim/custom/ctrlp.vim
source ~/.vim/custom/fzf.vim

" }}}
" Settings {{{

colorscheme dracula

" IO
set undofile
set nobackup
set noswapfile
set nowritebackup
set encoding=utf-8

" Mappings
set pastetoggle=<F2>
let mapleader="\<SPACE>"

" UI behevior
set mouse=a
set scrolloff=5
set shortmess+=c
set timeoutlen=2000
set updatetime=500
set guicursor=
      \n-v-c-sm:block,
      \i-ci-ve:ver25,
      \r-cr:hor20,
      \o:hor50,
      \a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,
      \sm:block-blinkwait175-blinkoff150-blinkon175

" Windows UI
set number
set cursorline
set splitbelow
set splitright
set signcolumn=yes

" Indentation
set tabstop=4
set expandtab
set autoindent
set shiftwidth=4

" Foldings
set foldcolumn=1
set foldmethod=indent
set foldlevelstart=5

" Text
set wrap
set list
set linebreak
set listchars=tab:▸\ ,trail:↔,nbsp:+

" Search
set hlsearch
set incsearch
set smartcase
set ignorecase

" Tags
set tags=./.ctags,.ctags

" }}}
" Variables {{{

let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
let g:airline_exclude_filetypes = ["list"]

let g:webdevicons_enable_ctrlp = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

let g:coc_node_path = '/Users/lastdanmer/.config/nvm/11.13.0/bin/node'
let g:dracula_colorterm = 1
let g:peekaboo_compact = 1
let g:semshi#update_delay_factor = 0.001

let g:python_host_prog  = '/usr/local/bin/python2'
let g:python3_host_prog = '/Users/lastdanmer/.pyenv/versions/3.7.2/bin/python'
let $PYTHONPATH = '/Users/lastdanmer/.pyenv/versions/jedi/lib/python3.7/site-packages'

" }}}
" Conditional options {{{
if !has('nvim')
  set t_Co=256
  set guicursor+=a:blinkon0
  "set mouse=nicr

  let &t_SI.="\e[5 q" " insert
  let &t_SR.="\e[4 q" " replace
  let &t_EI.="\e[1 q" " normal
endif

if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" }}}
" Highlights {{{

hi CursorLine ctermbg=NONE guibg=#303241

" }}}
" Abbreviations {{{

iab {{ {{ }}<Left><Left><Left>
inorea <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)

" }}}
" Autocommands {{{

augroup VimRc
  au BufNewFile,BufRead flake8 setf dosini

  au ColorScheme * call PythonHighlights()

  au FileType python call PythonHighlights()
  au FileType python call coc#config('python.pythonPath', systemlist('which python')[0])
  au FileType qf map <buffer> dd :RemoveQFItem<CR>

  au User AirlineAfterInit call AirlineInit()
	au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  au! CompleteDone * if pumvisible() == 0 | pclose | endif

  " coc.nvim root_patterns
  au FileType go let b:coc_root_patterns = ['go.mod', 'go.sum']
  au FileType python let b:coc_root_patterns = ['Pipfile', 'pyproject.toml', 'requirements.txt']
  au FileType javascript let b:coc_root_patterns = ['package.json', 'node_modules']
augroup END

" }}}
" Commands {{{

command! DirFiles Files %:h
command! CopyPath let @+ = expand('%:p')
command! EchoPath :echo(expand('%:p'))
command! Delallmarks delmarks A-Z0-9\"[]
command! FormatJSON %!python -m json.tool
command! -nargs=0 Format :call CocAction('format')
command! -range FormatSQL <line1>,<line2>!sqlformat --reindent --keywords upper --identifiers lower -
command! RemoveQFItem :call RemoveQFItem()
" command! ToggleNumber :call ToggleNumber()
command! SortImports %!isort -

" }}}
" Mappings {{{

" General one-key mappings
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
nnoremap { gT
nnoremap } gt
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap <silent>Y :call <SID>show_documentation()<CR>
inoremap <silent><expr> <C-x> coc#refresh()
inoremap <C-y> <C-o>:call CocActionAsync('showSignatureHelp')<CR>
" tnoremap <Esc> <C-\><C-n>

" [] Brackets movings
nmap <silent> [q :cp<CR>
nmap <silent> ]q :cn<CR>
nmap <silent> [d <Plug>(coc-diagnostic-prev)<CR>
nmap <silent> ]d <Plug>(coc-diagnostic-next)<CR>

" [G]oTo's
nmap <silent> gd :call CocActionAsync("jumpDefinition")<CR>
nmap <silent> gn :call CocActionAsync("jumpDefinition", "tabe")<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gl <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Tab & S-Tab for completion menu navigation
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Messages cleanup
nmap <silent> <Leader><BS> :echo ''<CR>
nmap <silent> <Leader><CR> :noh<CR>:echo ''<CR>

" <Leader> mappings
" General lists
nmap <Leader>b :Buffers<CR>
nmap <Leader>e :CtrlP<CR>
nmap <Leader>f :Files<CR>
nmap <Leader>` :Marks<CR>
nmap <Leader>t :Tags<CR>

" [T]ab actions
nmap <silent> <Leader>tn :tabnew<CR>
nmap <silent> <Leader>ts :tab split<CR>

" [V]isuals (views) & messages
nmap <silent> <Leader>vg :GitGutter<CR>
nmap <silent> <Leader>vl :Limelight!!<CR>
nmap <silent> <Leader>vn :call ToggleNumber()<CR>
nmap <silent> <Leader>vr :RainbowParentheses!!<CR>
" nmap <silent> <Leader>vs :syntax sync fromstart<CR>
nmap <Leader>vs :call CocActionAsync('showSignatureHelp')<CR>

" [R]efactorings & reformats
nmap <silent> <Leader>rs :SortImports<CR>
nmap <leader>rf <Plug>(coc-format-selected)
vmap <leader>rf <Plug>(coc-format-selected)

" [D]iagonostics
nmap <leader>dl :CocList diagnostics<CR>
nmap <leader>di <Plug>(coc-diagnostic-info)<CR>

" [Q]uickFix related mappings
nmap <silent> <leader>qo :copen<CR>
nmap <silent> <leader>qc :cclose<CR>
nmap <leader>qf <Plug>(coc-fix-current)

" }}}
" Functions {{{

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! PythonHighlights()
    hi semshiImported gui=NONE cterm=NONE
    hi semshiSelected guibg=#990045
endfunction

function! GetServerStatus()
  return get(g:, 'coc_status', '')
endfunction

function! AirlineInit()
  let g:airline_section_a = airline#section#create(['coc'])
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Delete item form QuickFix list
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  if len(qfall) > 0
    execute curqfidx + 1 . "cfirst"
    :copen
  else
    :cclose
  endif
endfunction

function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunction

call airline#parts#define_function('coc', 'GetServerStatus')

" }}}
" vim:foldmethod=marker:foldlevel=0

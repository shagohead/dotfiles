syntax enable
filetype plugin indent on

" Plugins {{{

call plug#begin('~/.local/share/nvim/plugged')

" File types
Plug 'cespare/vim-toml'
Plug 'chr4/nginx.vim'
Plug 'dag/vim-fish'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'pangloss/vim-javascript'
Plug 'Vimjas/vim-python-pep8-indent'

" Other
Plug '/usr/local/opt/fzf'
Plug 'airblade/vim-gitgutter'
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'chriskempson/base16-vim'
Plug 'dominikduda/vim_current_word'
" Plug 'godlygeek/tabular'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'ludovicchabant/vim-gutentags'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mgedmin/python-imports.vim'
Plug 'pbogut/fzf-mru.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wellle/targets.vim'
Plug 'Yggdroot/indentLine'

" With custom options
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}

call plug#end()

" source ~/.vim/custom/ctrlp.vim
source ~/.vim/custom/fzf.vim

" }}}
" Settings {{{

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

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
set nowrap
set list
set linebreak
set listchars=tab:▸\ ,trail:↔,nbsp:+

" Search
set hlsearch
set incsearch
set smartcase
set ignorecase

" Tags, files..
set grepprg=rg\ --vimgrep
set tags=./.ctags,.ctags

" }}}
" Variables {{{

" let g:airline_mode_map = {
"   \ '__'     : '-',
"   \ 'c'      : 'C',
"   \ 'ix'     : 'I',
"   \ 'multi'  : 'M',
"   \ 'ni'     : 'N',
"   \ 'no'     : 'N',
"   \ 'R'      : 'R',
"   \ 'Rv'     : 'R',
"   \ 's'      : 'S',
"   \ 'S'      : 'S',
"   \ ''     : 'S',
"   \ 't'      : 'T',
"   \ }
let g:airline_mode_map = {
  \ 'i'      : 'I',
  \ 'ic'     : 'I COMPL',
  \ 'n'      : 'N',
  \ 'c'      : '>',
  \ 'v'      : 'V',
  \ 'V'      : '↑ V',
  \ ''     : '^ V',
  \ }
let g:airline_powerline_fonts = 1
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
let g:airline_exclude_filetypes = ["list"]
let g:airline#extensions#virtualenv#enabled = 0
let g:airline#extensions#wordcount#enabled = 0
let g:coc_node_path = '/Users/lastdanmer/.config/nvm/11.13.0/bin/node'
let g:dracula_colorterm = 1
let g:fzf_mru_relative = 1
let g:gitgutter_enabled = 0
let g:gutentags_ctags_tagfile = '.ctags'
let g:gutentags_file_list_command = 'ctags.fish'
let g:peekaboo_compact = 0
let g:python_host_prog  = '/usr/local/bin/python2'
let g:python3_host_prog = '/Users/lastdanmer/.pyenv/versions/3.7.2/bin/python'
let g:vim_current_word#delay_highlight = 0
let g:vim_current_word#highlight_current_word = 1
let g:vim_current_word#highlight_only_in_focused_window = 1
let g:webdevicons_enable_ctrlp = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

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

hi CurrentWord gui=undercurl

" }}}
" Abbreviations {{{

iab {{ {{ }}<Left><Left><Left>
inorea <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)

" }}}
" Autocommands {{{

augroup VimRc
  au BufNewFile,BufRead flake8 setf dosini

  au! CompleteDone * if pumvisible() == 0 | pclose | endif

  au FileType python call coc#config('python.pythonPath', systemlist('which python')[0])
  au FileType qf map <buffer> dd :RemoveQFItem<CR>

  au User AirlineAfterInit call AirlineInit()
  au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  " coc.nvim root_patterns
  au FileType go let b:coc_root_patterns = ['go.mod', 'go.sum']
  au FileType python let b:coc_root_patterns = ['Pipfile', 'pyproject.toml', 'requirements.txt']
  au FileType javascript let b:coc_root_patterns = ['package.json', 'node_modules']
augroup END

" }}}
" Commands {{{

command! CopyPath let @+ = expand('%:p')
command! Delallmarks delmarks A-Z0-9\"[]
command! DirFiles Files %:h
command! EchoPath :echo(expand('%:p'))
command! GoDefTab :call CocActionAsync("jumpDefinition", "tabe")<CR>
command! FormatJSON %!python -m json.tool
command! -nargs=0 Format :call CocAction('format')
command! -range FormatSQL <line1>,<line2>!sqlformat --reindent --keywords upper --identifiers lower -
command! RemoveQFItem :call RemoveQFItem()
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
inoremap <silent><expr> <C-z> coc#refresh()
inoremap <C-y> <C-o>:call CocActionAsync('showSignatureHelp')<CR>
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
noremap <C-w>e <C-W>z
noremap <C-w><C-e> <C-W>z

" [] Brackets movings
nmap <silent> [q :cp<CR>
nmap <silent> ]q :cn<CR>
nmap <silent> [d <Plug>(coc-diagnostic-prev)<CR>
nmap <silent> ]d <Plug>(coc-diagnostic-next)<CR>

" [G]oTo's
nmap <silent> ge :call CocActionAsync("jumpDefinition", "edit")<CR>
" TODO: conditional split (vert or hor)
nmap <silent> gd :call CocActionAsync("jumpDefinition", "vsplit")<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gl <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" " Select ranges with <Tab> (by coc.nvim)
" nmap <silent> <Tab> <Plug>(coc-range-select)
" xmap <silent> <Tab> <Plug>(coc-range-select)
" xmap <silent> <S-Tab> <Plug>(coc-range-select-backword)

" Tab & S-Tab for completion menu navigation
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Messages cleanup
nmap <silent> <Leader><BS> :echo ''<CR>
nmap <silent> <Leader><CR> :noh<CR>:echo ''<CR>

" <Leader> mappings
" General lists
nmap <Leader>e :FZFMru<CR>
nmap <Leader>f :Files<CR>
nmap <Leader>` :Marks<CR>

" [L]lists (that can be closed with Esc)
nmap <Leader>ld :CocList diagnostics<CR>
nmap <Leader>lb :Buffers<CR>
nmap <Leader>lh :History<CR>
nmap <Leader>lm :Maps<CR>
nmap <Leader>lq :call ToggleQuickFix()<CR>
nmap <Leader>lt :Tags<CR>

" [R]efactorings & reformats
nmap <Leader>ri :ImportName<CR>
nmap <Leader>rs :SortImports<CR>
nmap <Leader>rf <Plug>(coc-fix-current)
nmap <Leader>rn <Plug>(coc-rename)
nmap <Leader>rr :Format<CR>
nmap <Leader>rv <Plug>(coc-format-selected)
vmap <Leader>rv <Plug>(coc-format-selected)

" [V]iews
nmap <Leader>vd <Plug>(coc-diagnostic-info)
nmap <Leader>vg :GitGutterToggle<CR>
nmap <Leader>vl :Limelight!!<CR>
nmap <Leader>vn :call ToggleNumber()<CR>
nmap <Leader>vr :RainbowParentheses!!<CR>
nmap <Leader>vs :call CocActionAsync('showSignatureHelp')<CR>

" [W]indows (and tabs)
nmap <silent> <Leader>wt :tabnew<CR>
nmap <silent> <Leader>ws :tab split<CR>

" }}}
" Functions {{{

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! AirlineInit()
  " let g:airline_section_x = ""
  "   \ %{airline#util#prepend("",0)}"
  "   \ %{airline#util#prepend(airline#extensions#vista#currenttag(),0)}"
  "   \ %{airline#util#prepend(airline#extensions#gutentags#status(),0)}"
  "   \ %{airline#util#prepend("",0)}"
  "   \ %{airline#util#wrap(airline#parts#filetype(),0)}"
  " let g:airline_section_z = airline#section#create(['coc'])
  let g:airline_section_z = '%{airline#util#wrap(GetServerStatus(),0)}'
endfunction

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

function! GetServerStatus()
  let l:status = get(g:, 'coc_status', '')
  if l:status =~ 'Python *'
    let l:status = substitute(l:status, 'Python ', '', '')
  endif
  if l:status =~ '.* 64-bit'
    let l:status = substitute(l:status, ' 64-bit', '', '')
  endif
  return l:status
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

function! ToggleQuickFix()
  if len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) > 0
    :cclose
  else
    :copen
  endif
endfunction

call airline#parts#define_function('coc', 'GetServerStatus')

" }}}
" vim:foldmethod=marker:foldlevel=0

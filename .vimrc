" Author: Vakhmin Anton <html.ru@gmail.com>
"
" Initial {{{

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
Plug 'easymotion/vim-easymotion'
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
Plug 'terryma/vim-expand-region'
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

" }}}
" Options {{{

" Colors
syntax enable
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" IO
set autoread
set undofile
set nobackup
set noswapfile
set nowritebackup
set encoding=utf-8

" Mappings
set pastetoggle=<F2>
let mapleader="\<SPACE>"
let maplocalleader="\<SPACE>l"

" UI behevior
set mouse=a
set scrolloff=1
set synmaxcol=800
set shortmess+=c
set updatetime=500

set notimeout
set ttimeout
set ttimeoutlen=10

set guicursor=
      \n-v-c-sm:block,
      \i-ci-ve:ver25,
      \r-cr:hor20,
      \o:hor50,
      \a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,
      \sm:block-blinkwait175-blinkoff150-blinkon175

" Windows UI
set noruler
set nonumber
set cursorline
set splitbelow
set splitright
set signcolumn=yes

" Titles
set title
set titleold=
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)

" Indentation
set tabstop=4
set expandtab
set autoindent
set shiftwidth=4

" Foldings
set foldcolumn=0
set foldmethod=indent
set foldlevelstart=99

" Text
set nowrap
set list
set linebreak
set listchars=tab:▸\ ,trail:↔,nbsp:+,extends:⟩,precedes:⟨
set fillchars=vert:\|

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

let g:python_host_prog  = '/Users/lastdanmer/.pyenv/versions/pynvim-2.7/bin/python'
let g:python3_host_prog = '/Users/lastdanmer/.pyenv/versions/pynvim/bin/python'

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
let $PYTHONPATH = '/Users/lastdanmer/.pyenv/versions/jedi/lib/python3.7/site-packages'

" }}}
" Highlights {{{

hi CurrentWord gui=undercurl
hi TabLine guibg=NONE
hi TabLineFill guibg=NONE
hi TabLineSel guibg=NONE
hi VertSplit guibg=NONE

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}

" }}}
" Abbreviations {{{

iab {{ {{ }}<Left><Left><Left>
inorea <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)

" }}}
" Autocommands {{{

" Only show cursorline in the current window and in normal mode.
augroup Colors
  au!
  au ColorScheme * call ApplyColors()
augroup END

augroup CursorLine
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" Make sure Vim returns to the same line when you reopen a file.
augroup LineReturn
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

augroup VimRc
  au!
  au BufNewFile,BufRead flake8 setf dosini

  au CompleteDone * if pumvisible() == 0 | pclose | endif

  au FileType qf map <buffer> dd :RemoveQFItem<CR>

  au User AirlineAfterInit call AirlineInit()
  au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

" }}}
" Functions {{{

function! ApplyColors() abort
  hi LineNr guibg=NONE
endfunction
call ApplyColors()

function! BuildQuickfixList(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

function! GetHighlight(group)
  let list = split(execute('hi ' . a:group), '\s\+')
  let dict = {}
  for item in list
    if match(item, '=') > 0
      let splited = split(item, '=')
      let dict[splited[0]] = splited[1]
    endif
  endfor
  return dict
endfunction

function! SearchMatchText()
    return @/[2:-3]
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
  if(&number == 1)
    set nonumber
  else
    set number
  endif
endfunction

function! ToggleQuickFix()
  if len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) > 0
    :cclose
  else
    :copen
  endif
endfunction


" }}}
" Commands {{{

command! CopyPath let @+ = expand('%:p')
command! Delallmarks delmarks A-Z0-9\"[]
command! EchoPath :echo(expand('%:p'))
command! FormatJSON %!python -m json.tool
command! -range FormatSQL <line1>,<line2>!sqlformat --reindent --keywords upper --identifiers lower -
command! RemoveQFItem :call RemoveQFItem()
command! SortImports %!isort -

" }}}
" Plugins Configuraion {{{

" Airline {{{

function! AirlineInactiveStatus(...)
  let builder = a:1
  let context = a:2
  call builder.add_section('file', '%f')
  return 1
endfunction

function! AirlineInit()
  let g:airline_section_z = '%{airline#util#wrap(GetServerStatus(),0)}'
endfunction

function! AirlineThemePatch(palette)
  let l:normal_fg = GetHighlight('Normal')['guifg']
  let l:normal_bg = GetHighlight('Normal')['guibg']
  " let g:test_palette = a:palette

  for section in keys(a:palette.inactive)
    let a:palette.inactive[section][0] = l:normal_fg
    let a:palette.inactive[section][1] = l:normal_bg
    if len(a:palette.inactive[section]) > 4
      let a:palette.inactive[section][4] = substitute(a:palette.inactive[section][4], 'reverse', '', '')
    endif
  endfor
endfunction

call airline#add_inactive_statusline_func('AirlineInactiveStatus')
call airline#parts#define_function('coc', 'GetServerStatus')

let g:airline_exclude_filetypes = ["list"]
let g:airline_highlighting_cache = 1
let g:airline_powerline_fonts = 1
let g:airline_theme_patch_func = 'AirlineThemePatch'

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

let g:airline_mode_map = {
  \ 'i'      : 'I',
  \ 'ic'     : 'I COMPL',
  \ 'n'      : 'N',
  \ 'c'      : '>',
  \ 'v'      : 'V',
  \ 'V'      : '↑ V',
  \ ''     : '^ V',
  \ }

let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'y', 'z', 'warning', 'error']]
let g:airline#extensions#virtualenv#enabled = 0
let g:airline#extensions#wordcount#enabled = 0

let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" }}}
" COC {{{

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

command! GoDefTab :call CocActionAsync("jumpDefinition", "tabe")<CR>
command! -nargs=0 Format :call CocAction('format')

let g:coc_node_path = '/Users/lastdanmer/.config/nvm/11.13.0/bin/node'

" }}}
" FZF {{{

function! s:edit_devicon_prepended_file(item)
  let l:file_path = a:item[4:-1]
  execute 'silent e' l:file_path
endfunction

command! DirFiles Files %:h
command! -bang -nargs=* Find
      \ call fzf#vim#grep('rg
      \ --column --line-number
      \ --no-heading --fixed-strings
      \ --ignore-case --no-ignore
      \ --hidden --follow
      \ --glob "!.git/*" --color "always"
      \ '.shellescape(<q-args>), 1, <bang>0)

let g:fzf_action = {
      \ 'ctrl-l': function('BuildQuickfixList'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit'}
let g:fzf_layout = {'window': '13new'}
let g:fzf_mru_relative = 1
let g:fzf_tags_command = 'ctags.sh'

" }}}
" Gutentags {{{

let g:gutentags_ctags_tagfile = '.ctags'
let g:gutentags_exclude_filetypes = ['gitcommit', 'gitrebase']
let g:gutentags_file_list_command = 'ctags.fish'

" }}}
" Other {{{

let g:dracula_colorterm = 1
let g:gitgutter_enabled = 0
let g:peekaboo_compact = 0
let g:vim_current_word#delay_highlight = 0
let g:vim_current_word#highlight_current_word = 1
let g:vim_current_word#highlight_only_in_focused_window = 1
let g:webdevicons_enable_ctrlp = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

" }}}

" }}}
" Filetype Specific {{{

" fish {{{

augroup filetype_fish
  au!
  au FileType fish setlocal tabstop=4
  au FileType fish setlocal shiftwidth=4
  au FileType fish setlocal expandtab
  au FileType fish setlocal foldmethod=indent
augroup END

" }}}
" GO {{{

augroup filetype_go
  au!
  au FileType go setlocal noexpandtab
  au FileType go let b:ale_fixers = ['gofmt']
  au FileType go let b:coc_root_patterns = ['go.mod', 'go.sum']
augroup END

" }}}
" HTML {{{

augroup filetype_html
  au!
  au FileType html setlocal tabstop=2
  au FileType html setlocal shiftwidth=2
  au FileType html setlocal softtabstop=2
  au FileType html setlocal expandtab
augroup END

" }}}
" JavaScript {{{

augroup filetype_js
  au!
  au FileType javascript setlocal tabstop=2
  au FileType javascript setlocal shiftwidth=2

  au FileType javascript let b:ale_linters = ['eslint', 'standard']
  au FileType javascript let b:ale_fixers = ['eslint', 'standard']
  au FileType javascript let b:ale_javascript_xo_options = '--space --global=$'
  au FileType javascript let b:ale_javascript_standard_options = '--global $ --global WebSocket'
  au FileType javascript let b:coc_root_patterns = ['package.json', 'node_modules']
augroup END

" }}}
" Python {{{

augroup filetype_py
  au!
  au FileType python setlocal tabstop=4
  au FileType python setlocal shiftwidth=4
  au FileType python setlocal expandtab

  au FileType python let b:ale_linters = ['flake8', 'pylint']
  au FileType python let b:coc_root_patterns = ['Pipfile', 'pyproject.toml', 'requirements.txt']
  au FileType python call coc#config('python.pythonPath', systemlist('which python')[0])

  au FileType python iab <buffer> pdb import pdb; pdb.set_trace()
  au FileType python iab <buffer> ipdb import ipdb; ipdb.set_trace()

  au FileType python nnoremap <buffer> <LocalLeader>i :ImportName<CR>
  au FileType python nnoremap <buffer> <LocalLeader>l :CocCommand python.runLinting<CR>
  au FileType python nnoremap <buffer> <LocalLeader>s :SortImports<CR>
augroup END

" }}}
" VimL {{{

augroup filetype_vim
  au!
  au FileType vim setlocal tabstop=2
  au FileType vim setlocal shiftwidth=2
augroup END

" }}}
" YAML {{{

augroup filetype_yaml
  au!
  au FileType yaml setlocal tabstop=2
  au FileType yaml setlocal shiftwidth=2
  au FileType yaml setlocal softtabstop=2
  au FileType yaml setlocal expandtab
augroup END

" }}}

" }}}
" Mappings {{{

" Disabling arrow movings
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
" noremap <C-,> :call SearchMatchText()

" Tabpage movings
nnoremap { gT
nnoremap } gt
" nnoremap # #N
" nnoremap * *N

" Window jumps
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Insert mode one-char movings
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

nnoremap zkk z10k
nnoremap zjj z10j
nnoremap zhh z10h
nnoremap zll z10l

" Paste yank register
nnoremap <C-p> "0p
vnoremap <C-p> "0p

" Documentation preview window
nnoremap <silent>Y :call <SID>show_documentation()<CR>

" Refresh CoC.nvim completion sources
inoremap <silent><expr> <C-z> coc#refresh()
" inoremap <C-y> <C-o>:call CocActionAsync('showSignatureHelp')<CR>

" Execute macro over selected lines range
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

" Close preview window
noremap <C-w>e :pclose<CR>
noremap <C-w><C-e> :pclose<CR>

" Brackets jumps
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nnoremap <silent> [q :cp<CR>
nnoremap <silent> ]q :cn<CR>

" Definition jumps & lists
nnoremap <silent> ge :call CocActionAsync("jumpDefinition", "edit")<CR>
" TODO: conditional split (vert or hor)
nnoremap <silent> gd :call CocActionAsync("jumpDefinition", "vsplit")<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gl <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Tab & S-Tab for completion menu navigation
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Messages cleanup
nnoremap <silent> <Leader><BS> :echo ''<CR>
nnoremap <silent> <Leader><CR> :noh<CR>:echo ''<CR>

" <Leader> mappings
"
" currently available:
" a
" g
" i
" j
" k
" l
" p
" u
" x
" y
" z
"
nnoremap <Leader>` :Marks<CR>
nnoremap <Leader>= :Format<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>c :call ToggleQuickFix()<CR>
nnoremap <Leader>d :CocList diagnostics<CR>
nnoremap <Leader>e :FZFMru<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>m :Maps<CR>
nnoremap <Leader>n <Plug>(coc-rename)

nnoremap <Leader>og :GitGutterToggle<CR>
nnoremap <Leader>ol :Limelight!!<CR>
nnoremap <Leader>on :call ToggleNumber()<CR>
nnoremap <Leader>or :RainbowParentheses!!<CR>

nnoremap <Leader>q :quit<CR>
nnoremap <Leader>r :%s//g<Left><Left>
xnoremap <Leader>r :s//g<Left><Left>
nnoremap <Leader>s :call CocActionAsync('showSignatureHelp')<CR>
nnoremap <Leader>t :Tags<CR>
nmap <Leader>v <Plug>(coc-diagnostic-info)
nnoremap <Leader>w :write<CR>

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
" vim:foldmethod=marker:foldlevel=0

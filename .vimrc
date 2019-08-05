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

let g:python_host_prog  = '/usr/local/bin/python2'
let g:python3_host_prog = '/Users/lastdanmer/.pyenv/versions/3.7.2/bin/python'

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
let $PYTHONPATH = '/Users/lastdanmer/.pyenv/versions/jedi/lib/python3.7/site-packages'

" }}}
" Highlights {{{

hi CurrentWord gui=undercurl

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

  au FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
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

function! AirlineThemePatch(palette)
  let l:normal = GetHighlight('Normal')['guifg']
  for key in keys(a:palette)
      if key != 'accents'
          let a:palette[key].airline_c[1] = 'NONE'
          let a:palette[key].airline_c[0] = l:normal
          let a:palette[key].airline_x[0] = l:normal
      endif
  endfor
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

call airline#parts#define_function('coc', 'GetServerStatus')

let g:airline_highlighting_cache = 1
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
let g:airline_theme_patch_func = 'AirlineThemePatch'
let g:airline_exclude_filetypes = ["list"]
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'z', 'warning', 'error']]
let g:airline#extensions#virtualenv#enabled = 0
let g:airline#extensions#wordcount#enabled = 0

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
" TODO: add initial path from argument (DirFiles are broken)
" TODO: fix broken hotkeys
" try:
"   - call wrap to get sink function and options
"   - call custom sink with wrapper data
" command! -bang -nargs=? -complete=dir Files
"       \ call fzf#run({
"       \ 'source': $FZF_DEFAULT_COMMAND.' | devicon-lookup',
"       \ 'sink': function('s:edit_devicon_prepended_file'),
"       \ 'window': '13new'})
"       " \ call fzf#run(fzf#wrap('files', {
"       " \ 'options': '--expect=ctrl-v,ctrl-x,ctrl-l,ctrl-t', 
"       " \ 'source': $FZF_DEFAULT_COMMAND.' | devicon-lookup',
"       " \ 'sink': function('s:edit_devicon_prepended_file'),
"       " \ '_action': {
"       "   \ 'ctrl-v': 'vsplit',
"       "   \ 'ctrl-x': 'split',
"       "   \ 'ctrl-l': function('<SNR>20_build_quickfix_list'),
"       "   \ 'ctrl-t': 'tab split'}
"       " \ }))
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
" Other {{{

let g:dracula_colorterm = 1
let g:gitgutter_enabled = 0
let g:gutentags_ctags_tagfile = '.ctags'
let g:gutentags_file_list_command = 'ctags.fish'
let g:peekaboo_compact = 0
let g:vim_current_word#delay_highlight = 0
let g:vim_current_word#highlight_current_word = 1
let g:vim_current_word#highlight_only_in_focused_window = 1
let g:webdevicons_enable_ctrlp = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

" }}}

" }}}
" Mappings {{{

" General one-key mappings
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
" noremap <C-,> :call SearchMatchText()

nnoremap { gT
nnoremap } gt
" nnoremap # #N
" nnoremap * *N

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
nnoremap <silent> [q :cp<CR>
nnoremap <silent> ]q :cn<CR>
nnoremap <silent> [d <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]d <Plug>(coc-diagnostic-next)

" [G]oTo's
nnoremap <silent> ge :call CocActionAsync("jumpDefinition", "edit")<CR>
" TODO: conditional split (vert or hor)
nnoremap <silent> gd :call CocActionAsync("jumpDefinition", "vsplit")<CR>
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gl <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

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
" q
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

nnoremap <Leader>r :%s//g<Left><Left>
xnoremap <Leader>r :s//g<Left><Left>
nnoremap <Leader>s :call CocActionAsync('showSignatureHelp')<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>v <Plug>(coc-diagnostic-info)
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

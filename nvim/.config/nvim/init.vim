" Author: Vakhmin Anton <html.ru@gmail.com>
"

filetype plugin indent on

" Plugins {{{

call plug#begin('~/.local/share/nvim/plugged')
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'cespare/vim-toml'
Plug 'chr4/nginx.vim'
Plug 'chriskempson/base16-vim'
Plug 'dag/vim-fish'
Plug 'haya14busa/is.vim'
Plug 'justinmk/vim-sneak'
Plug 'liuchengxu/vim-which-key', {'on': ['WhichKey', 'WhichKey!']}
Plug 'ludovicchabant/vim-gutentags'
Plug 'luochen1990/rainbow'
Plug 'michaeljsmith/vim-indent-object'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sudar/vim-arduino-syntax'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Yggdroot/indentLine'
Plug 'Vimjas/vim-python-pep8-indent'
" temporarily plugged:
Plug 'janko/vim-test'
Plug 'tpope/vim-dispatch'
Plug 'neomake/neomake'
Plug 'benmills/vimux'
call plug#end()

" }}}
" Colors & Syntax {{{

if has('syntax')
  if &diff
    syntax off
  elseif !exists('g:syntax_on')
    syntax enable
  endif
endif

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}
" Options {{{

" IO
set autoread
set exrc secure
set encoding=utf-8

set path+=**
set wildignore+=*.pyc

set nobackup
set noswapfile
set nowritebackup
set undodir=~/.local/share/nvim/undo
set undofile

let g:loaded_python_provider = 0
let g:loaded_python3_provider = 0

" Mappings
set pastetoggle=<F2>
let mapleader="\<SPACE>"
let maplocalleader="\\"

" UI behevior
set mouse=a
set shortmess+=c

set numberwidth=2
set scrolloff=1
set sidescrolloff=5
set synmaxcol=800
set updatetime=500

set lazyredraw
set notimeout
set ttimeout
set ttimeoutlen=0

set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25,r-cr:hor20,o:hor50
set sessionoptions-=options
set viewoptions-=options

" Windows UI
set noruler
set nonumber
set noshowcmd
set noshowmode
set nocursorline
set splitbelow
set splitright
set signcolumn=yes
set wildmenu

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
set linebreak
if has('multi_byte') && &encoding ==# 'utf-8'
  set list
  let &listchars = 'trail:↔,tab:· ,extends:⟩,precedes:⟨,nbsp:×'
  let &fillchars = 'vert:|'

  if has('patch-7.4.338')
    let &showbreak = nr2char(8618).' ' " Show ↪ at the beginning of wrapped lines
    set breakindent
    set breakindentopt=sbr
  endif
endif

" Search
set hlsearch
set incsearch
set smartcase
set ignorecase

" Tags, files..
set grepprg=rg\ --vimgrep
set tags=./.ctags,.ctags

" Completion
set completeopt=noinsert,menuone,noselect

" Environment variables
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all '.$FZF_DEFAULT_OPTS

if !has('nvim')
  set t_Co=256

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

if exists('+termguicolors') && $TERM == 'alacritty'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" }}}
" Mappings {{{

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

nnoremap <M-[> gT
nnoremap <M-]> gt
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap <M-p> "+p
vnoremap <M-p> "+p

nnoremap <silent> [q :cp<CR>
nnoremap <silent> ]q :cn<CR>
nnoremap <silent> gp :call utils#grep_references()<CR>
nnoremap <silent> <Leader><BS> :echo ''<CR>
nnoremap <silent> <Leader><CR> :noh<CR>:echo ''<CR>
xnoremap @ :<C-u>call utils#execute_macro_over_visual_range()<CR>

nnoremap <Leader>` :Marks<CR>
nnoremap <Leader>a <Nop>
nnoremap <Leader>b :b<Space>
nnoremap <Leader>cc :call quickfix#toggle()<CR>
nnoremap <Leader>cd :call quickfix#clear()<CR>
nnoremap <Leader>cs :call quickfix#save()<CR>
nnoremap <Leader>cl :call quickfix#load()<CR>
nnoremap <Leader>e :History<CR>
nnoremap <Leader>f :find<Space>
nnoremap <Leader>g :call utils#toggle_numbers()<CR>
vnoremap <Leader>g :call utils#toggle_numbers()<CR>gv
nnoremap <Leader>h <Nop>
nnoremap <Leader>j <Nop>
nnoremap <Leader>k :call utils#which_key()<CR>
nnoremap <Leader>l <Nop>
nnoremap <Leader>o <Nop>
nnoremap <Leader>p :CocList outline<CR>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>r :%s//g<Left><Left>
xnoremap <Leader>r :s//g<Bar>noh<Left><Left><Left><Left><Left><Left>
nnoremap <Leader>s <Nop>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>u <Nop>
nnoremap <Leader>v :GitGutterToggle<CR> " VCS toggle
nnoremap <Leader>w :write<CR>
nnoremap <Leader>x :bd<CR>
nnoremap <Leader>z :Files<CR>

" Mappings & macros
nnoremap <Leader>mm :Maps<CR>
" Edit register
nnoremap <Leader>mr :<C-u><C-r><C-r>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-f><Left>

" S-Tab for completion menu navigation
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : utils#check_back_space() ? "\<Tab>" : coc#refresh()

nnoremap <silent> Y :call utils#show_documentation()<CR>
nnoremap <silent> [d :call CocActionAsync('diagnosticPrevious')<CR>
nnoremap <silent> ]d :call CocActionAsync('diagnosticNext')<CR>
nnoremap <silent> gd :call CocActionAsync('jumpDefinition', 'edit')<CR>
nnoremap <silent> gs :call CocActionAsync('jumpDefinition', 'vsplit')<CR>
nnoremap <silent> gr :call CocActionAsync('jumpReferences')<CR>
nnoremap <silent> <Leader>= :call CocActionAsync('format')<CR>
nnoremap <silent> <Leader>d :call CocActionAsync('diagnosticInfo')<CR>
nnoremap <silent> <Leader>i :call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>
nnoremap <silent> <Leader>n :call CocActionAsync('rename')<CR>
nnoremap <silent> <Leader>y :call CocActionAsync('showSignatureHelp')<CR>
inoremap <C-y> <C-o>:call CocActionAsync('showSignatureHelp')<CR>

" }}}
" Commands {{{

" Search inside / outside syntax group
command! -nargs=+ -complete=command SInside  call utils#search_inside(<f-args>)
command! -nargs=+ -complete=command SOutside call utils#search_outside(<f-args>)
command! -nargs=0 -complete=command SGroup   echo(synIDattr(synID(line("."), col("."), 0), "name"))

" }}}
" Autocommands {{{

augroup vimrc
  au!

  " FileTypes
  au BufNewFile,BufRead flake8,pycodestyle setf dosini

  " Return to previous line
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$")
        \| execute 'normal! g`"zvzz'
        \| endif

  " Highlights cleanup
  au ColorScheme * call utils#update_colors()

  " Menu autoclose
  au CompleteDone * if pumvisible() == 0 && getcmdwintype() != ':' | pclose | endif

  " Highlight current word
  au CursorHold * silent call CocActionAsync('highlight')

  " Or maybe change style of highlights?
  " au CmdlineEnter [/\?] :set hlsearch
  " au CmdlineLeave [/\?] :set nohlsearch

  " Word wrapping
  au FileType html,jinja.html,htmldjango,python setlocal wrap

  " QuickFix item remove
  au FileType qf map <buffer> dd :call quickfix#remove()<CR>

  " Tests mappings
  let g:runserver_command = 'runserver'
  au FileType python execute "nmap <buffer> <LocalLeader>r :VimuxRunCommand '".runserver_command."'<CR>"
  au FileType python nmap <buffer> <LocalLeader>t :TestNearest<CR>
  au FileType python nmap <buffer> <LocalLeader>v :TestNearest -strategy=vimux<CR>

  " Show wordwrap column in insert mode
  au InsertEnter *.go,*.js,*.md,*.py set colorcolumn=89
  au InsertLeave * set colorcolumn=

  " CoC recommendation (which currently i dont understand)
  au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  " Gutentags status messages
  au User GutentagsUpdated echo 'Tags updated'
  au User GutentagsUpdating echo 'Updating tags..'

  " TMUX window title with filename
  if exists('$TMUX')
    if !exists('$NORENAME') && !has('gui')
      " TODO: call system async
      " https://github.com/prabirshrestha/async.vim
      "
      " Automatic rename of tmux window
      " Set option set-option -g allow-rename off in ~/.tmux.conf
      " au BufEnter * if empty(&buftype)
      "       \| call system('tmux rename-window '.expand('%:t:S'))
      "       \| endif
      " au VimLeave * call system('tmux set-window automatic-rename on')
    endif
  endif
augroup end

call utils#update_colors()

" }}}

" vim:foldmethod=marker

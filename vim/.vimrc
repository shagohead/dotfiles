" Sensible defaults
" TODO diff with:
" https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
source $VIMRUNTIME/defaults.vim
autocmd! vimStartup

if &term =~ 'alacritty'
	set mouse=a
endif

" Установка vim-plug, при его отсуствии.
let s:plug_path = '~/.vim/autoload/plug.vim'
if !filereadable(expand(s:plug_path))
	let s:src = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	silent execute '!curl -fLo '.s:plug_path.' --create-dirs '.s:src
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Менеджмент плагинов vim-plug'ом,
" обходится примерно в 20ms на старте.
call plug#begin('~/.local/share/vim-plugged')

Plug 'airblade/vim-gitgutter'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
Plug 'junegunn/gv.vim'
Plug 'chriskempson/base16-vim'
Plug 'ryanoasis/vim-devicons'

" TODO AUTOCOMPLETE:
" https://github.com/Shougo/ddc.vim (нет автоимпорта)
" vim-lsp, vim-lsc.. etc
" .. вернуться на coc...? (нет, конечно)

" POPUP FYZZY FINDERS:
" https://github.com/liuchengxu/vim-clap
" https://github.com/junegunn/fzf.vim
" ctrl.p?

Plug 'dstein64/vim-startuptime', {'on': ['StartupTime']}
let g:startuptime_tries = 20

Plug 'liuchengxu/vim-which-key', {'on': ['WhichKey', 'WhichKey!']}

call plug#end()

" Подсветка разделителей в диффах слияния.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Взаимодействие с файловой системой.
set path+=**
set grepprg=rg\ --vimgrep
set wildignore+=*.pyc
set sessionoptions-=options
set viewoptions-=options
set undodir=~/.local/share/vim-undo
set undofile

" Ввод.
" ? set expandtab
set linebreak
set smartcase
set ignorecase
set keymap=russian-jcukenmac
set iminsert=0
set completeopt=menuone,noinsert,noselect,preview
set concealcursor=nc
" set imsearch=0
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" Поведение UI.
set splitbelow
set splitright
set scrolloff=1
set laststatus=2
set numberwidth=2
set updatetime=250
set guifont=Iosevka\ Nerd\ Font:h14
set spelllang=ru_yo,en_us
set foldmethod=indent
set foldlevelstart=99
set diffopt+=foldcolumn:0
if winwidth(0) < 200
	set diffopt-=vertical
	set diffopt+=horizontal
else
	set diffopt-=horizontal
	set diffopt+=vertical
endif

" Заголовок окна.
set title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)

" Special chars repr
let &listchars = 'trail:↔,extends:⟩,precedes:⟨,nbsp:×,tab:ͺ '
let &fillchars = 'vert:|'

" Автокоманды.
augroup vimrc
  au!
  au BufNewFile,BufRead flake8,pycodestyle setf dosini
  au BufNewFile,BufRead .gitconfig.* setf gitconfig
	au ColorScheme * call UpdateColors()
  au FileType go setlocal noexpandtab
  " au FileType html,jinja.html,htmldjango,markdown,python setlocal wrap
  " au FileType fish setlocal foldmethod=expr
  " au FileType help setlocal conceallevel=0
  au FileType html,htmldjango,javascript,lua,yaml,vim setlocal ts=2 sw=2 sts=2
  au FileType markdown setlocal fo-=l fo+=o
  au FileType python setlocal dict+=~/.config/nvim/dictionary/python fo-=t fo+=ro tw=88
  au InsertEnter * set cc=+1
  au InsertLeave * set cc=
  au VimResized * wincmd =
augroup END

function! UpdateColors()
  hi DiffAdd ctermfg=NONE guifg=NONE
  hi DiffChange ctermfg=NONE guifg=NONE
  hi DiffText ctermfg=NONE guifg=NONE
  hi GitGutterAdd ctermbg=NONE guibg=NONE
  hi GitGutterChange ctermbg=NONE guibg=NONE
  hi GitGutterDelete ctermbg=NONE guibg=NONE
  hi SignColumn ctermbg=NONE guibg=NONE
  hi TabLine ctermbg=NONE guibg=NONE
  hi TabLineFill ctermbg=NONE guibg=NONE
  hi TabLineSel ctermbg=NONE guibg=NONE
	hi VertSplit ctermbg=NONE guibg=NONE
endfunction

" Применение цветовой схемы терминала из base16-shell.
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace = 256
  source ~/.vimrc_background
endif

" https://github.com/tpope/tpope/blob/master/.vimrc

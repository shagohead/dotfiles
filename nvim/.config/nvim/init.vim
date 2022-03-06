lua require('plugins')

" Взаимодействие с файловой системой.
set noautoread
set path+=**
set grepprg=rg\ --vimgrep
set wildignore+=*.pyc
set undofile

" Ввод.
set linebreak
set smartcase
set ignorecase
set keymap=russian-jcukenmac
set iminsert=0
set completeopt=menuone,noinsert,noselect,preview
set concealcursor=c
let mapleader = ' '
let maplocalleader = ' '

" Поведение UI.
set splitbelow
set splitright
set scrolloff=1
set numberwidth=2
set updatetime=250
set mouse=a
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

" Разбивка строки.
if has('patch-7.4.338')
	set breakindent
	set breakindentopt=sbr
	let &showbreak = nr2char(8618).' ' " ↪ вначале разбитой строки
endif

" Заголовок окна.
set title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)

" Провайдеры Python.
" let g:loaded_python_provider = 0 FIXME: понять надо ли это тут (проверить
" запуск вима с питоновскими файлами и без)
if empty(glob(expand('~/.pyenv/virtualenvs/pynvim/bin/python3'))) == 0
  let g:python3_host_prog = '~/.pyenv/virtualenvs/pynvim/bin/python3'
else
  let g:loaded_python3_provider = 0
end

" Отключение неиспользуемых встроенных модулей.
let s:disabled_built_ins = ['gzip', 'matchit', 'matchparen', 'shada_plugin', 'tar', 'tarPlugin', 'zip', 'zipPlugin']
for n in s:disabled_built_ins
	exec 'let g:loaded_'.n.' = 1'
endfor

sign define DiagnosticSignError text= texthl=DiagnosticSignError
sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint

" Автокоманды и функции для них.
augroup vimrc
	autocmd!
	au BufNewFile,BufRead flake8,pycodestyle setf dosini
	au BufNewFile,BufRead .gitconfig.* setf gitconfig
	au BufNewFile,BufRead *init*.lua nmap K <Cmd>execute "help ".expand("<cword>")<CR>
	au ColorScheme * call UpdateColors()
	au FileType fish setlocal cms=#\ %s
	au FileType fish,gitconfig,sql setlocal ts=4 sw=4 sts=4 et
	au FileType go setlocal noet fo+=ro nowrap
	au FileType GV nmap <buffer> o .show<CR>
	au FileType go,html,htmldjango,javascript,lua,markdown,yaml,vim setlocal ts=2 sw=2 sts=2
	au FileType lua,vim setlocal nowrap
	au FileType lua,vim nmap <buffer> <Leader>G <Cmd>execute "!open https://github.com/".expand("<cfile>")<CR>
	au FileType markdown nmap <buffer> <Leader>J <Cmd>execute "!open https://j.jetstyle.in/browse/".expand("<cWORD>")<CR>
	au FileType markdown nmap <buffer> <Leader>M <Cmd>execute "!open https://gitlab.jetstyle.in/jetstyle/nti/talent-backend/-/merge_requests/".expand("<cword>")<CR>
	au FileType markdown setlocal fo-=l fo+=o
	au FileType python setlocal dict+=~/.config/nvim/dictionary/python fo-=t fo+=ro tw=88
	au FileType sql nmap <buffer> <Leader>= <Cmd>%!pg_format<CR>
	au FileType sql nmap <buffer> <CR> <Cmd>%DB<CR>
	au FileType sql xmap <buffer> <CR> <Cmd>'<,'>DB<CR>
	au FileType sql setlocal cms=--\ %s
	au InsertEnter * set cc=+1
	au InsertLeave * set cc=
	au VimEnter * call BindDiffSplit()
	au VimResized * call UpdateWindowOptions()
augroup END

function! BindDiffSplit()
	if len($DIFF_BASE)
		nmap <Leader>d :exec ':Gdiffsplit '.$DIFF_BASE<CR>
		command! -nargs=0 DiffBaseSplit execute ':Gdiffsplit '.$DIFF_BASE
	endif
endfunction

function! UpdateColors()
  hi DiffAdd ctermfg=NONE guifg=NONE
  hi DiffChange ctermfg=NONE guifg=NONE
  hi DiffText ctermfg=NONE guifg=NONE
  hi Folded ctermbg=NONE guibg=NONE
  hi GitGutterAdd ctermbg=NONE guibg=NONE
  hi GitGutterChange ctermbg=NONE guibg=NONE
  hi GitGutterDelete ctermbg=NONE guibg=NONE
  hi SignColumn ctermbg=NONE guibg=NONE
  hi TabLine ctermbg=NONE guibg=NONE
  hi TabLineFill ctermbg=NONE guibg=NONE
  hi TabLineSel ctermbg=NONE guibg=NONE
	hi TSDefinition cterm=reverse
	hi VertSplit ctermbg=NONE guibg=NONE
endfunction

function! UpdateWindowOptions()
	if &columns < 200
		set diffopt-=vertical
		set diffopt+=horizontal
	else
		set diffopt-=horizontal
		set diffopt+=vertical
	endif
endfunction

" FIXME: найти применение или удалить
function! CheckBackSpace()
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Подсветка разделителей в конфликтах.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Применение цветовой схемы терминала из base16-shell.
if empty(glob(expand('~/.vimrc_background'))) == 0
    let base16colorspace = 256
    source ~/.vimrc_background
endif

" Дополнение <C-L> очисткой поиска и апдейтом диффа.
if has('nvim-0.6') == 0
	nnoremap <silent> <C-L> :noh<C-R>=has("diff")?"<Bar>diffupdate":""<CR><CR><C-L>
end

" Смена файла по <C-H> вместо <C-^> в normal.
nnoremap  
" Переключение langmap в normal на <C-^>, по аналогии с i_CTRL-^ (и c_CTRL-^).
nnoremap  a

" Выход из режима terminal
tnoremap <Esc><Esc> <C-\><C-n>

" <C-G> будет использоваться для всех статусных сообщений (а еще есть <G><C-G>).
nnoremap <C-G><C-G> <C-G>

" Закрытие tabpage
nnoremap <C-W><S-c> <Cmd>tabclose<CR>

" Более быстрая альтернатива для <"+> и <"0>
nnoremap <M-y> "+
xnoremap <M-y> "+
nnoremap <M-p> "0
xnoremap <M-p> "0

" Для более быстрого выбора объектов без пробелов перед ними,
" особенно полезно с объектами из tpope/vim-surround.
nnoremap I 2i
xnoremap I 2i

" Y работающий как D, т.е. с текущего символа и до конца строки.
if has('nvim-0.6') == 0
	nnoremap Y y$
end

" Переключение по элементам списка QuickFix.
nnoremap [q <Cmd>cp<CR>
nnoremap ]q <Cmd>cn<CR>

" Ресайз окна по кол-ву строк.
nnoremap <C-W>0 <Cmd>execute ":resize".line("$")<CR>

" Применение макроса в VISUAL.
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange() abort
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Поиск разделитилей merge диффов.
nnoremap <Leader>c /\\(<\\<Bar>>\\<Bar>=\\<Bar><Bar>\\)\\{7}<CR>

command! -nargs=0 Grep execute ':grep '.expand('<cword>')
command! -nargs=0 OpenFileDir silent call system('open '.expand('%:p:h:~'))
command! -nargs=0 FilePathEcho echo expand('%:p')
command! -nargs=0 FilePathCopy let @+ = expand('%:p')

" TODO: <Leader>q для переключения окна qf.

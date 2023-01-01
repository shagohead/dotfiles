" Author: Vakhmin Anton <html.ru@gmail.com>
" https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
lua require('config.plugins')
exe 'augroup vimrc'
autocmd!

" Чтение и запись {{{

set undofile

" }}}
" Поиск файлов {{{

set path+=**
set wildignore+=*.pyc
set grepprg=rg\ --vimgrep
set tags=./tags;,tags,tags_venv

" }}}
" Поиск по буферу {{{

set smartcase
set ignorecase

" }}}
" Окна {{{

set title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)

" }}}
" Ввод {{{

let mapleader = ' '
let maplocalleader = ' '

set mouse=a
set completeopt=menuone,noinsert,noselect,preview

if has('nvim-0.6') == 0
  nnoremap <silent> <C-L> :noh<C-R>=has("diff")?"<Bar>diffupdate":""<CR><CR><C-L>
end

" От случайных закрытий окон
" nnoremap <C-w>O <C-W>o
" nnoremap <C-w>o <Nop>
" nnoremap <C-w><C-o> <Nop>

tnoremap <Esc><Esc> <C-\><C-n>
nnoremap <C-W>0 <Cmd>execute ":resize".line("$")<CR>
nnoremap <C-W>! <Cmd>execute ":vertical resize".max(map(getline(1,'$'), 'len(v:val)'))<CR>
nnoremap <C-W><S-c> <Cmd>tabclose<CR>
nnoremap [q <Cmd>cp<CR>
nnoremap ]q <Cmd>cn<CR>

" Кириллический ввод с поддержкой маппингов VIM.
" «Универсальное» переключение режима использования langmap.
" - такой маппинг удобней чем <C-^>
" - при использовании в Normal, не конфликтует с переключением файла по <C-^>
" - позволяет переключать режим langmap будучи в Normal
set keymap=russian-jcukenmac
set iminsert=0
nnoremap <C-S> <Cmd>call ToggleInputMethod()<CR>
inoremap <C-S> <Cmd>call ToggleInputMethod()<CR>
cnoremap <C-S> <Cmd>call ToggleInputMethod()<CR>
function! ToggleInputMethod() abort
  let l:new = &iminsert ? 0 : 1
  if mode() == "n"
    let &iminsert=l:new
  elseif mode() == "i"
    let l:cmd = "\<C-o>:setl iminsert=" .. l:new .. "\<CR>"
    execute "call feedkeys(l:cmd)"
  else
    call feedkeys('')
  endif
  doautocmd <nomodeline> User InputMethodChanged
endfunction

" <C-G> будет использоваться для всех статусных сообщений (а еще есть <G><C-G>).
nnoremap <C-G><C-G> <C-G>

" Более быстрая альтернатива для <"+> и <"0>.
nnoremap <M-y> "+
xnoremap <M-y> "+
nnoremap <M-p> "0
xnoremap <M-p> "0

" Для более быстрого выбора объектов без пробелов перед ними,
" особенно полезно с объектами из tpope/vim-surround.
nnoremap I 2i
xnoremap I 2i

" <Y> работающий как <D>, т.е. с текущего символа и до конца строки.
if has('nvim-0.6') == 0
  nnoremap Y y$
end

" Для объявления в плагинах (Telescope/FZF/..)
nnoremap <Leader>b <Nop>
nnoremap <Leader>e <Nop>
nnoremap <Leader>f <Nop>
nnoremap <Leader>l <Nop>
nnoremap <Leader>o <Nop>
nnoremap <Leader>p <Nop>
nnoremap <Leader>q <Nop>
nnoremap <Leader>t <Nop>
nnoremap <Leader>s <Cmd>syntax sync fromstart<CR>
nnoremap <Leader>? :map <Leaderr<BS>><CR>
nnoremap <Leader>w <Cmd>write<CR>

" Применение макроса к выделенному тексту.
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange() abort
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Маппинги по типам файлов.
au FileType fzf tnoremap <buffer> <Esc><Esc> <Nop>
au FileType fzf tnoremap <buffer> <C-o> <Nop>
au FileType man setlocal nomodifiable
au FileType GV nmap <buffer> o .show<CR>
au FileType sql nmap <buffer> <Leader>= <Cmd>%!pg_format<CR>
au FileType sql xmap <buffer> <Leader>= :!pg_format<CR>
au FileType sql nmap <buffer> <CR> vap<CR>
au FileType sql xmap <buffer> <CR> :'<,'>DB<CR>

" }}}
" Вывод {{{

set guifont=Iosevka\ Nerd\ Font\ Mono:h14
set concealcursor=c
" set relativenumber
" set numberwidth=2
" set signcolumn=number
set signcolumn=auto:2
set scrolloff=1
set linebreak
set list

if has('patch-7.4.338')
  set breakindent
  set breakindentopt=sbr
  let &showbreak = nr2char(8618).' ' " ↪ вначале разбитой строки
endif

au InsertEnter * set cc=+1
au InsertLeave * set cc=

" }}}
" Тайминги {{{

set updatetime=250

" }}}
" Форматирование и спеллчекинг {{{

set fo+=ro
set spelllang=ru_yo,en_us
set fillchars=diff:/
set listchars=tab:>\ ,trail:•,nbsp:␣

au FileType go,html,htmldjango,javascript,lua,markdown,sh,yaml,vim setl ts=2 sw=2 sts=2
au FileType git,GV setl nornu
" FIXME: URL строится не корректно
au FileType kitty setl kp=open\ https://sw.kovidgoyal.net/kitty/conf/\\#opt-kitty.\
au FileType GV setl lcs-=trail:-
au FileType python setl dict+=~/.config/nvim/dictionary/python fo-=t tw=88
au FileType fish,gitconfig,sql setl ts=4 sw=4 sts=4 et
au FileType go setl noet nowrap lcs=trail:-,nbsp:+,tab:\ \ 
au FileType markdown setl fo-=l
au FileType html,htmldjango,javascript,lua,sh,vim setl et
au FileType lua,vim setl nowrap
au FileType fish setl cms=#\ %s
au FileType sql setl cms=--\ %s formatprg=pg_format\ -

" }}}
" Команды {{{

command! -nargs=0 BrowseGitHub execute "!open https://github.com/".expand("<cfile>")
" FIXME: Удалить перед публикацией. Может быть перенести в локальный vim файл, вне репы
command! -nargs=0 BrowseGitLab execute "!open https://gitlab.jetstyle.in/jetstyle/nti/talent-backend/-/merge_requests/".expand("<cword>")
command! -nargs=0 BrowseJira execute "!open https://j.jetstyle.in/browse/".expand("<cWORD>")
command! -nargs=0 FindConflicts /\\(<\\<Bar>>\\<Bar>=\\<Bar><Bar>\\)\\{7}
command! -nargs=0 GrepThis execute ':grep '.expand('<cword>')
command! -nargs=0 FilePathEcho echo expand('%:p')
command! -nargs=0 FileDirOpen silent call system('open '.expand('%:p:h:~'))
command! -nargs=0 LAddLine laddexpr expand("%").":".line(".").":".getline(".")
command! -nargs=0 LClear call setloclist(0, [], 'r')

" }}}
" Символы {{{

sign define DiagnosticSignError text= texthl=DiagnosticSignError
sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint

" }}}
" Подсветка {{{

" Подсветка разделителей в конфликтах.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Для цветовых тем на основе base16, использующих всю таблицу ANSI.
let base16colorspace = 256
colorscheme cterm

let g:markdown_fenced_languages = ['python', 'go', 'lua', 'vim']

" }}}
" Встроенные плагины {{{

" Использование более производительного filetype.lua.
let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

" Загрузка ftdetect файлов из плагинов (которая выполнялась в filetype.vim).
if !exists('g:did_load_ftdetect')
  runtime! ftdetect/*.vim
  runtime! ftdetect/*.lua
endif

let s:disabled_built_ins = ['gzip', 'matchit', 'matchparen', 'shada_plugin', 'tar', 'tarPlugin', 'zip', 'zipPlugin']
for n in s:disabled_built_ins
  exec 'let g:loaded_'.n.' = 1'
endfor

" }}}
" Провайдеры внешних плагинов {{{

if empty(glob(expand('~/.pyenv/virtualenvs/pynvim/bin/python3'))) == 0
  let g:python3_host_prog = '~/.pyenv/virtualenvs/pynvim/bin/python3'
else
  let g:loaded_python3_provider = 0
end

" }}}
" Дифф {{{

set diffopt+=foldcolumn:0
set diffopt+=indent-heuristic
set diffopt+=algorithm:histogram

au VimEnter * call BindDiffMode()
au VimEnter * call BindDiffSplit()
au VimResized * call UpdateWindowOptions()

function! BindDiffMode()
  if &diff
    set nonumber
    set norelativenumber
    lua vim.diagnostic.disable()
    Gitsigns toggle_linehl
  endif
endfunction

function! BindDiffSplit()
  if len($DIFF_BASE)
    nmap <Leader>d :exec ':Gdiffsplit '.$DIFF_BASE<CR>
    command! -nargs=0 DiffBaseSplit execute ':Gdiffsplit '.$DIFF_BASE
    execute ':Gitsigns change_base '.$DIFF_BASE
  endif
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

call UpdateWindowOptions()

command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_
		\ | diffthis | wincmd p | diffthis

" }}}
" Фолдинг {{{

set foldmethod=indent
set foldlevelstart=99

" }}}

exe 'augroup END'

" vim: foldmethod=marker fdl=0

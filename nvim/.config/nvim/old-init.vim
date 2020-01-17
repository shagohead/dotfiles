" Author: Vakhmin Anton <html.ru@gmail.com>
"
" Initial {{{

filetype plugin indent on

" Variables {{{

" Neo/vim system variables
let g:python_host_prog  = '/Users/shagohead/.pyenv/virtualenvs/pynvim-2/bin/python'
let g:python3_host_prog = '/Users/shagohead/.pyenv/virtualenvs/pynvim/bin/python'

" Conditional plugins
" TODO: set by filetype (use coc_nvim for vimscript)
let g:plug_coc_nvim = 1
" TODO: add lang servers for viml & js
" TODO: try to get previews with syntax highlights (like coc for py and viml)
let g:plug_lang_client = 0
let g:plug_lsp = 1

" Environment variables
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all --color=dark --color=fg:15,bg:0,hl:6,hl+:6 --color=info:2,prompt:1,pointer:12,marker:4,spinner:11,header:6'
" let $PYTHONPATH = '/Users/shagohead/.pyenv/virtualenvs/jedi/lib/python3.8/site-packages'

" }}}
" Plugins {{{

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" TODO: optimize startup https://github.com/junegunn/vim-plug/wiki/tips
call plug#begin('~/.local/share/nvim/plugged')

" FILETYPES
Plug 'cespare/vim-toml'
Plug 'chr4/nginx.vim'
Plug 'dag/vim-fish'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'pangloss/vim-javascript'
Plug 'Vimjas/vim-python-pep8-indent'

" NAVIGATION FILE/BUFFER
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-unimpaired'

" MOTIONS THROUGH BUFFER/WINDOW
Plug 'haya14busa/is.vim'

" CODE SELECTION & TEXT OBJECTS
Plug 'michaeljsmith/vim-indent-object'
Plug 'terryma/vim-expand-region'
Plug 'wellle/targets.vim'

" CODE FORMATTING
" Plug 'AndrewRadev/splitjoin.vim'
" Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" CHANGETREE, GIT, TAGS
Plug 'airblade/vim-gitgutter'
" TDOO: try to replace with LSP symbol navigation
Plug 'ludovicchabant/vim-gutentags'
Plug 'mbbill/undotree'

" UI
Plug 'chriskempson/base16-vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'liuchengxu/vim-which-key', {'on': ['WhichKey', 'WhichKey!']}
" Plug 'kshenoy/vim-signature'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'

if g:plug_coc_nvim
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

if g:plug_lang_client
  Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
endif

if g:plug_lsp
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
endif

call plug#end()

" }}}
" Options {{{

" Colors
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

" IO
set autoread
set undofile
set nobackup
set noswapfile
set nowritebackup
set encoding=utf-8
set exrc secure

" Mappings
set pastetoggle=<F2>
let mapleader="\<SPACE>"
let maplocalleader=","

" UI behevior
set mouse=a
set shortmess+=c

set numberwidth=2
set scrolloff=1
set sidescrolloff=5
set synmaxcol=800
set updatetime=500

set notimeout
set ttimeout
set ttimeoutlen=10

set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175
set sessionoptions-=options
set viewoptions-=options

" Windows UI
set noruler
set nonumber
set noshowmode
set nocursorline
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

" Completion
set completeopt=noinsert,menuone,noselect

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

" Make sure Vim returns to the same line when you reopen a file.
" TODO: exclude commit messages
augroup LineReturn
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup end

" Initial augroup
augroup VimRc
  au!
  au BufNewFile,BufRead flake8,pycodestyle setf dosini
  au ColorScheme * call ApplyColors()
  " Or maybe change style of highlights?
  " au CmdlineEnter [/\?] :set hlsearch
  " au CmdlineLeave [/\?] :set nohlsearch
  au InsertEnter *.go,*.js,*.md,*.py set colorcolumn=89
  au InsertLeave * set colorcolumn=
  au FileType qf map <buffer> dd :RemoveQFItem<CR>

  if g:plug_coc_nvim
    au CompleteDone * if pumvisible() == 0 && getcmdwintype() != ':' | pclose | endif
    au CursorHold * silent call CocActionAsync('highlight')
    au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  endif
augroup end

" }}}
" Functions {{{

function! ApplyColors() abort
  hi MatchParen gui=bold,underline guibg=NONE

  if stridx(g:colors_name, 'light') > -1
    set background=light
  endif

  if &background == 'dark'
    hi Cursor guifg=black guibg=brwhite
    call g:Base16hi('MatchParen', g:base16_gui0C, "", "", "") " cyan
    call g:Base16hi('StatusLine', "", g:base16_gui00, "", "")
    call g:Base16hi('StatusLineNC', "", g:base16_gui00, "", "")
  else
    hi Cursor guifg=brwhite guibg=black
    call g:Base16hi('MatchParen', g:base16_gui0E, "", "", "") " magenta
  endif

  hi LineNr guibg=NONE
  hi CursorLineNr gui=NONE guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
  call g:Base16hi('IncSearch', "", g:base16_gui07, "", "") " bright white
endfunction
call ApplyColors()

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

" Find references with grep
function! GrepReferences()
  let l:word = expand('<cword>')
  if len(l:word) < 1
    echo 'There is no word under cursor'
  else
    let l:ext = expand('%:e')
    let l:shell = "rg --column --line-number --no-heading --color=always --smart-case
          \ --type-add '".l:ext.":*.".l:ext."' -t".l:ext." "
    call fzf#vim#grep(l:shell.shellescape(l:word), 1, 0)
  endif
endfunction

function! SetStatusLine()
  let l:status = ["%1*".mode()]
  " TODO: use powerline or unicode symbols for servers

  let l:coc = get(g:, "coc_status", "")
  if l:coc =~ "Python *"
    " TODO: get python version
    call add(l:status, "")
  elseif l:coc != ""
    call add(l:status, l:coc)
  endif

  let l:lsp = lsp#get_server_status()
  if l:lsp != "pyls: not running"
    call add(l:status, l:lsp)
  endif

  call add(l:status, expand('%'))
  return join(l:status, " | ")
endfunction

" Go to previous buffer in jumplist
function! JumpToPrevBuffer()
  let l:jumps = getjumplist()
  let l:list = l:jumps[0]
  let l:pos = l:jumps[1]
  let l:bufnum = bufnr()
  let l:idx = 0

  " TODO: start from previous item not first
  for l:jump in reverse(l:list)
    let l:idx += 1
    if l:jump.bufnr != l:bufnum
      execute "normal " . l:idx . "\<C-o>"
      return
    endif
  endfor

  echo 'There is no previous buffers to jump'
endfunction

" Jump to placed sign (used with LanguageClient for diagnostics)
function! JumpToSign(names, go_back)
  let l:next = 0
  let l:line = line('.')

  for l:buffer_signs in sign_getplaced(bufname())
    if a:go_back == 1
      call reverse(l:buffer_signs.signs)
    endif

    for l:sign in l:buffer_signs.signs
      if index(a:names, l:sign.name) == -1
        continue
      endif

      if a:go_back == 1
        if l:sign.lnum < l:line
          let l:next = l:sign.id
          break
        endif
      else
        if l:sign.lnum > l:line
          let l:next = l:sign.id
          break
        endif
      endif
    endfor
  endfor

  if l:next == 0
    echo 'There is no (visible) signs to go'
  else
    execute 'sign jump '.l:next
  endif
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

function! StatusExt()
  let l:status = []
  let l:coc = get(g:, "coc_status", "")
  if l:coc != ""
    call add(l:status, "CoC.nvim: ".l:coc)
  endif
  call add(l:status, "LSP: ".lsp#get_server_status())
  return join(l:status, " | ")
endfunction

" Toggle relativenumber option
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunction

let g:quickfixlists = {}

" Toggle QuickFix window
function! QuickFixToggle()
  if len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) > 0
    :cclose
  else
    :copen
  endif
endfunction

" Clear QuickFix list
function! QuickFixClear()
  cclose
  call setqflist([], 'r')
endfunction

" Save QuickFix list in variable
function! QuickFixSave()
  let l:initial = input("Save QF list with key (in form: `key:[message]`): ")
  if len(l:initial) < 1
    return
  endif

  let l:initial_list = split(l:initial, ":")
  let l:key = l:initial_list[0]
  let l:message = ""
  if len(l:initial_list) > 1
    let l:message = l:initial_list[1]
  endif

  let g:quickfixlists[l:key] = {'message': l:message, 'list': getqflist()}
  echo "\n"
  echom "QuickFix list saved at key " . l:key
endfunction

" Load QuickFix list from variable
function! QuickFixLoad()
  cclose
  let l:available = []

  for key in keys(g:quickfixlists)
    let l:message = g:quickfixlists[l:key].message
    if l:message
      let l:title = " - " . l:key . ":" . l:message
    else
      let l:title = " - " . l:key
    endif
    call add(l:available, l:title)
  endfor

  if len(l:available) < 1
    echo "There is no save QuickFix lists"
    return
  endif

  let l:available_str = join(l:available, "\n")
  let l:key = input("Available lists:\n" . l:available_str . "\nEnter list key: ")
  if len(l:key) < 1
    echo "\nQuickFixLoad aborted"
    return
  endif

  if !has_key(g:quickfixlists, l:key)
    echo "\nThere is no saved list with key: " . l:key
    return
  endif

  call setqflist(g:quickfixlists[l:key].list, 'r')
  copen
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

augroup CoC_config
  au!
  au FileType typescript,json setl formatexpr=CocAction('formatSelected')
  au FileType typescript xmap <buffer> if <Plug>(coc-funcobj-i)
  au FileType typescript xmap <buffer> af <Plug>(coc-funcobj-a)
  au FileType typescript omap <buffer> if <Plug>(coc-funcobj-i)
  au FileType typescript omap <buffer> af <Plug>(coc-funcobj-a)
  au FileType typescript,python nmap <buffer> <silent> <LocalLeader>v <Plug>(coc-range-select)
  au FileType typescript,python xmap <buffer> <silent> <LocalLeader>v <Plug>(coc-range-select)
augroup end

let g:coc_node_path = '/Users/shagohead/.config/nvm/13.2.0/bin/node'

" }}}
" FZF {{{

function! BuildQuickfixList(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let opts = {
        \ 'relative': 'win',
        \ 'width': winwidth(winnr()),
        \ 'height': 13,
        \ 'row': winheight(winnr()) - 13,
        \ 'col': 0,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

function! s:edit_devicon_prepended_file(item)
  let l:file_path = a:item[4:-1]
  execute 'silent e' l:file_path
endfunction

function! s:buffsink(lines)
  if len(a:lines) < 2
    return
  endif

  let Cmd = get(get(g:, 'fzf_action'), a:lines[0])
  if type(Cmd) == type('')
    execute 'silent' Cmd
  elseif a:lines[0] == 'alt-d'
    let buffers = []
    for line in a:lines[1:]
      call add(buffers, matchstr(line, '\[\zs[0-9]*\ze\]'))
    endfor
    " TODO: only non-active buffers: execute('buffers a')
    execute 'bdelete' join(buffers, ' ')
    return
  else
    let b = matchstr(a:lines[1], '\[\zs[0-9]*\ze\]')
    execute 'buffer' b
  endif
endfunction

command! -bar -bang -nargs=? -complete=buffer Buffers
      \ call fzf#vim#buffers(<q-args>, {
      \ 'sink*': function('s:buffsink'),
      \ 'options': '--multi --expect alt-d',
      \ }, <bang>0)
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
let g:fzf_layout = {'window': 'call FloatingFZF()'}
let g:fzf_tags_command = 'ctags.sh'

" }}}
" Gutentags {{{

let g:gutentags_ctags_tagfile = '.ctags'
let g:gutentags_exclude_filetypes = ['gitcommit', 'gitrebase']
let g:gutentags_file_list_command = 'ctags.fish'

" " }}}
" LanguageClient {{{

if g:plug_lang_client
  set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
endif

let g:LanguageClient_hoverPreview = 'Always'
" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_loggingFile =  expand('~/.local/share/nvim/LanguageClient.log')
" let g:LanguageClient_serverStderr = expand('~/.local/share/nvim/LanguageServer.log')
let g:LanguageClient_rootMarkers = {
      \ 'javascript': ['project.json'],
      \ 'python': ['Pipfile', 'pyproject.toml', 'requirements.txt'],
      \ 'rust': ['Cargo.toml'],
      \ }
let g:lsp_python_mspls = ['dotnet', 'exec', '/Users/shagohead/Sources/opensource/python-language-server/output/bin/Release/Microsoft.Python.LanguageServer.dll']
let g:lsp_python_pyls = ['pyls']
let g:LanguageClient_serverCommands = {
      \ 'python': g:lsp_python_pyls,
      \ 'rust': ['rustup', 'run', 'stable', 'rls'],
      \ }

augroup LanguageClient_config
  au!
  " au User LanguageClientStarted setlocal signcolumn=yes
  " au User LanguageClientStopped setlocal signcolumn=auto
  " au User LanguageClientDiagnosticsChanged
augroup end

" }}}
" LSP {{{

function! s:on_lsp_buffer_enabled() abort
  " setlocal omnifunc=lsp#complete
  " setlocal signcolumn=yes
  " TODO: set server status
  let b:lsp_enabled = 1
  nmap <buffer> <F6> <plug>(lsp-definition)
  nmap <buffer> <F7> :LspHover<CR>
  nmap <buffer> <F8> :LspSignatureHelp<CR>
endfunction

if executable('pyls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': {'pyls': {'plugins': {'jedi_signature_help': {'enabled': v:true} } } }
        \ })
endif

augroup lsp_install
  au!
  au BufEnter * let b:lsp_enabled = 0
  au User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup end

" }}}
" Other {{{

let g:dracula_colorterm = 1
let g:gitgutter_enabled = 0
let g:peekaboo_compact = 0
let g:vim_current_word#delay_highlight = 0
let g:vim_current_word#highlight_current_word = 1
let g:vim_current_word#highlight_only_in_focused_window = 1

" }}}

" }}}
" Filetype Specific {{{

" Multiple {{{

augroup filetype_multiple
  au!
  au FileType html,jinja.html,python setlocal wrap
  " au FileType help,html,jinja.html,vim set colorcolumn=
augroup end

" }}}
" fish {{{

augroup filetype_fish
  au!
  au FileType fish setlocal tabstop=4
  au FileType fish setlocal shiftwidth=4
  au FileType fish setlocal expandtab
  au FileType fish setlocal foldmethod=indent
augroup end

" }}}
" GO {{{

augroup filetype_go
  au!
  au FileType go setlocal noexpandtab
  au FileType go let b:ale_fixers = ['gofmt']
  au FileType go let b:coc_root_patterns = ['go.mod', 'go.sum']
augroup end

" }}}
" HTML {{{

augroup filetype_html
  au!
  au FileType html setlocal tabstop=2
  au FileType html setlocal shiftwidth=2
  au FileType html setlocal softtabstop=2
  au FileType html setlocal expandtab
augroup end

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
augroup end

" }}}
" LESS {{{

augroup filetype_less
  au!
  au FileType less setlocal tabstop=2
  au FileType less setlocal shiftwidth=2
  au FileType less setlocal softtabstop=2
  au FileType less setlocal expandtab
augroup end

" }}}
" Python {{{

augroup filetype_py
  au!
  au FileType python setlocal tabstop=4
  au FileType python setlocal shiftwidth=4
  au FileType python setlocal expandtab
  au FileType python let b:ale_linters = ['flake8']
  au FileType python let b:coc_root_patterns = ['Pipfile', 'pyproject.toml', 'requirements.txt']
  au FileType python iab <buffer> pdb import pdb; pdb.set_trace()
  au FileType python iab <buffer> ipdb import ipdb; ipdb.set_trace()

  if g:plug_coc_nvim
    au FileType python nnoremap <buffer> <LocalLeader>l :CocCommand python.runLinting<CR>
    " au FileType python nnoremap <buffer> <LocalLeader>s :CocCommand editor.action.organizeImport<CR>
  endif
augroup end

" }}}
" VimL {{{

augroup filetype_vim
  au!
  au FileType vim setlocal tabstop=2
  au FileType vim setlocal shiftwidth=2
augroup end

" }}}
" YAML {{{

augroup filetype_yaml
  au!
  au FileType yaml setlocal tabstop=2
  au FileType yaml setlocal shiftwidth=2
  au FileType yaml setlocal softtabstop=2
  au FileType yaml setlocal expandtab
augroup end

" }}}

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
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

nnoremap { gT
nnoremap } gt
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap <M-p> "+p
vnoremap <M-p> "+p

nnoremap <silent> [q :cp<CR>
nnoremap <silent> ]q :cn<CR>
nnoremap <silent> gp :call GrepReferences()<CR>
nnoremap <silent> <C-w>w :pclose<CR>
nnoremap <silent> <C-w><C-w> :pclose<CR>
nnoremap <silent> <Leader><BS> :echo ''<CR>
nnoremap <silent> <Leader><CR> :noh<CR>:echo ''<CR>

" Execute macro over selected lines range
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

nnoremap <Leader>` :Marks<CR>
nnoremap <Leader>a <Nop>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>cc :call QuickFixToggle()<CR>
nnoremap <Leader>cd :call QuickFixClear()<CR>
nnoremap <Leader>cs :call QuickFixSave()<CR>
nnoremap <Leader>cl :call QuickFixLoad()<CR>
nnoremap <Leader>e :History<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>g :call ToggleNumber()<CR>
" <Leader>h* mappings in use by GitGutter
nnoremap <Leader>j <Nop>
nnoremap <Leader>k <Nop>
nnoremap <Leader>l <Nop>
nnoremap <Leader>o <Nop>
nnoremap <Leader>p <Nop>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>r :%s//g<Left><Left>
xnoremap <Leader>r :s//g<Left><Left>
nnoremap <Leader>s <Nop>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>u <Nop>
nnoremap <Leader>v :GitGutterToggle<CR> " VCS toggle
nnoremap <Leader>w :write<CR>
nnoremap <Leader>x :bd<CR>
nnoremap <Leader>z <Nop>

" Mappings & macros
nnoremap <Leader>mm :Maps<CR>
" Edit register
nnoremap <Leader>mr :<C-u><C-r><C-r>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-f><Left>

" S-Tab for completion menu navigation
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

if g:plug_coc_nvim
  " Refresh CoC.nvim completion sources
  " inoremap <silent><expr> <C-z> coc#refresh()
  nnoremap <silent> Y :call <SID>show_documentation()<CR>
  nnoremap <silent> [d :call CocActionAsync('diagnosticPrevious')<CR>
  nnoremap <silent> ]d :call CocActionAsync('diagnosticNext')<CR>
  nnoremap <silent> gd :call CocActionAsync('jumpDefinition', 'edit')<CR>
  nnoremap <silent> gs :call CocActionAsync('jumpDefinition', 'vsplit')<CR>
  nnoremap <silent> gr :call CocAction('jumpReferences')<CR>
  nnoremap <silent> <Leader>= :call CocAction('format')<CR>
  nnoremap <silent> <Leader>d :call CocActionAsync('diagnosticInfo')<CR>
  nnoremap <silent> <Leader>i :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
  nnoremap <silent> <Leader>n :call CocActionAsync('rename')<CR>
  nnoremap <silent> <Leader>y :call CocActionAsync('showSignatureHelp')<CR>
  inoremap <C-y> <C-o>:call CocActionAsync('showSignatureHelp')<CR>

  " Tab for completion menu navigation
  inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : coc#refresh()
  inoremap <expr><CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
else
  " Tab for completion menu navigation
  inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : "\<C-x>\<C-o>"
  inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

if g:plug_lang_client && g:plug_coc_nvim == 0
  nnoremap <F5> :call LanguageClient_contextMenu()<CR>
  nnoremap <silent> Y :call LanguageClient#textDocument_hover()<CR>
  nnoremap <silent> [d :call JumpToSign(['LanguageClientWarning', 'LanguageClientError'], 1)<CR>
  nnoremap <silent> ]d :call JumpToSign(['LanguageClientWarning', 'LanguageClientError'], 0)<CR>
  nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
  nnoremap <silent> gs :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
  nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
  nnoremap <silent> <Leader>= :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <silent> <Leader>d :call LanguageClient#explainErrorAtPoint()<CR>
  nnoremap <silent> <Leader>n :call LanguageClient#textDocument_rename()<CR>
  nnoremap <silent> <Leader>y :call LanguageClient#textDocument_signatureHelp()<CR>
endif

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
" vim:foldmethod=marker
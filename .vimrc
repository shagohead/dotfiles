" Author: Vakhmin Anton <html.ru@gmail.com>
"
" Initial {{{

filetype plugin indent on

" Variables {{{

" Neo/vim system variables
let g:python_host_prog  = '/Users/lastdanmer/.pyenv/versions/pynvim-2.7/bin/python'
let g:python3_host_prog = '/Users/lastdanmer/.pyenv/versions/pynvim/bin/python'

" Conditional plugins
" TODO: set by filetype (use coc_nvim for vimscript)
let g:plug_coc_nvim = 1
" TODO: add lang servers for viml & js
" TODO: try to get previews with syntax highlights (like coc for py and viml)
let g:plug_lang_client = 0

" Environment variables
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
let $PYTHONPATH = '/Users/lastdanmer/.pyenv/versions/jedi/lib/python3.7/site-packages'

" }}}
" Plugins {{{

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" TODO: optimize startup https://github.com/junegunn/vim-plug/wiki/tips
call plug#begin('~/.local/share/nvim/plugged')

" GROUP: filetypes
Plug 'cespare/vim-toml'
Plug 'chr4/nginx.vim'
Plug 'dag/vim-fish'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'pangloss/vim-javascript'

" GROUP: navigation file/buffer
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-unimpaired'

" GROUP: motions through buffer/window
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
" Plug 'ripxorip/aerojump.nvim', {'do': ':UpdateRemotePlugins'}

" GROUP: code selection & text objects
Plug 'michaeljsmith/vim-indent-object'
Plug 'terryma/vim-expand-region'
Plug 'wellle/targets.vim'

" GROUP: code formatting
" Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'Vimjas/vim-python-pep8-indent'

" GROUP: changetree, git, tags
Plug 'airblade/vim-gitgutter'
" TDOO: try to replace with LSP symbol navigation
Plug 'ludovicchabant/vim-gutentags'
Plug 'mbbill/undotree'

" GROUP: UI
Plug 'junegunn/limelight.vim'
Plug 'chriskempson/base16-vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'ryanoasis/vim-devicons'
" TODO: try to replace with another *line plugin
" TODO: or set minimal airline config
" TODO: or set own minimal statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'

if g:plug_coc_nvim
  Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
endif

if g:plug_lang_client
  Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
endif

call plug#end()

" }}}
" Options {{{

" Colors
if has('syntax')
  if !exists('g:syntax_on')
    syntax enable
  endif

  if &diff
    syntax diff
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

" Mappings
set pastetoggle=<F2>
let mapleader="\<SPACE>"
let maplocalleader="\<SPACE>\<SPACE>"

" UI behevior
set mouse=a
set scrolloff=1
set sidescrolloff=5
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
set sessionoptions-=options
set viewoptions-=options

" Windows UI
set noruler
set nonumber
set noshowcmd
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

augroup Colors
  au!
  au ColorScheme * call ApplyColors()
augroup end

" Make sure Vim returns to the same line when you reopen a file.
" TODO: exclude commit messages
augroup LineReturn
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup end

augroup VimRc
  au!
  au BufNewFile,BufRead flake8,pycodestyle setf dosini
  au CompleteDone * if pumvisible() == 0 | pclose | endif
  au FileType qf map <buffer> dd :RemoveQFItem<CR>
  au User AirlineAfterInit call AirlineInit()
  au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" }}}
" Functions {{{

function! ApplyColors() abort
  hi LineNr guibg=NONE
  hi MatchParen gui=bold,underline guifg=LightCyan guibg=NONE
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

" Переключение на предыдущий буфер
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

function! ToggleNumber()
  if(&number == 1)
    set nonumber
  else
    set number
  endif
endfunction

let g:quickfixlists = {}

function! QuickFixToggle()
  if len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) > 0
    :cclose
  else
    :copen
  endif
endfunction

function! QuickFixClear()
  cclose
  call setqflist([], 'r')
endfunction

function! QuickFixErase()
  cclose
endfunction

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

let g:coc_node_path = '/Users/lastdanmer/.config/nvm/12.10.0/bin/node'

" }}}
" FZF {{{

function! BuildQuickfixList(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
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
let g:fzf_layout = {'window': '13new'}
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
let g:lsp_python_mspls = ['dotnet', 'exec', '/Users/lastdanmer/Sources/opensource/python-language-server/output/bin/Release/Microsoft.Python.LanguageServer.dll']
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

" Multiple {{{

augroup filetype_multiple
  au!
  au FileType html,jinja.html,python setlocal wrap
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
  " au FileType python nnoremap <buffer> <LocalLeader>i :ImportName<CR>

  if g:plug_coc_nvim
    " au FileType python call coc#config('python.pythonPath', systemlist('which python')[0])
    au FileType python nnoremap <buffer> <LocalLeader>l :CocCommand python.runLinting<CR>
    " au FileType python nnoremap <buffer> <LocalLeader>s :CocCommand editor.action.organizeImport<CR>
  endif

  if g:plug_lang_client
    " au FileType python let $PYTHONPATH = systemlist('python -c \"import sys; print(sys.path[-1])\"')[0]
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
nnoremap <silent> <C-w>w :pclose<CR>
nnoremap <silent> <C-w><C-w> :pclose<CR>
nnoremap <silent> <Leader><BS> :echo ''<CR>
nnoremap <silent> <Leader><CR> :noh<CR>:echo ''<CR>

" Execute macro over selected lines range
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

nnoremap <Leader>` :Marks<CR>
" nmap <Leader>as <Plug>(AerojumpSpace)
" nmap <Leader>ab <Plug>(AerojumpBolt)
" nmap <Leader>aa <Plug>(AerojumpFromCursorBolt)
" nmap <Leader>ad <Plug>(AerojumpDefault)
nnoremap <Leader>a <Nop>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>cc :call QuickFixToggle()<CR>
nnoremap <Leader>cd :call QuickFixClear()<CR>
nnoremap <Leader>ce :call QuickFixErase()<CR>
nnoremap <Leader>cs :call QuickFixSave()<CR>
nnoremap <Leader>cl :call QuickFixLoad()<CR>
nnoremap <Leader>e :History<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>g <Nop>
" <Leader>h* mappings in use by GitGutter
nnoremap <Leader>j <Nop>
nnoremap <Leader>k <Nop>
nnoremap <Leader>l <Nop>
nnoremap <Leader>p <Nop>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>r :%s//g<Left><Left>
xnoremap <Leader>r :s//g<Left><Left>
nnoremap <Leader>s <Nop>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>u <Nop>
nnoremap <Leader>v <Nop>
nnoremap <Leader>w :write<CR>
nnoremap <Leader>x :bd<CR>
nnoremap <Leader>z <Nop>

" Mappings & macros
nnoremap <Leader>mm :Maps<CR>
" Edit register
nnoremap <Leader>mr :<C-u><C-r><C-r>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-f><Left>

" Options toggle
nnoremap <Leader>og :GitGutterToggle<CR>
nnoremap <Leader>ol :Limelight!!<CR>
nnoremap <Leader>on :call ToggleNumber()<CR>
nnoremap <Leader>or :RainbowParentheses!!<CR>

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
" vim:foldmethod=marker:foldlevel=0

-- https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/init.lua

-- Алиасы интерфейса к объектам vim.
local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
local opt = vim.opt
local o, wo, bo = vim.o, vim.wo, vim.bo
local autocmd = require 'utils'.autocmd
local map = require 'utils'.map

require 'plugins'

-- Options configured on top of nvim defaults:
-- https://neovim.io/doc/user/vim_diff.html#nvim-defaults
  
-- Взаимодействие с файловой системой.
opt.grepprg = 'rg --vimgrep'
opt.path:append '**'
opt.wildignore:append '*.pyc'
opt.undofile = true

-- Ввод.
-- ? opt.expandtab = true
opt.linebreak = true
opt.smartcase = true
opt.ignorecase = true
opt.keymap = 'russian-jcukenmac'
opt.iminsert = 0
opt.completeopt = {'menuone', 'noinsert', 'noselect', 'preview'}
opt.concealcursor = 'nc'
g.mapleader = ' '
g.maplocalleader = ' '

-- Поведение UI.
opt.scrolloff = 1
opt.numberwidth = 2
opt.updatetime = 250
opt.mouse = 'a'
opt.guifont = 'Iosevka Nerd Font:h14'
opt.spelllang = 'ru_yo,en_us'
opt.foldmethod = 'indent'
opt.foldlevelstart = 99
opt.diffopt:append 'foldcolumn:0'
if fn.winwidth(0) < 200 then
  opt.diffopt:remove 'vertical'
  opt.diffopt:append 'horizontal'
else
  opt.diffopt:remove 'horizontal'
  opt.diffopt:append 'vertical'
end

-- Разбивка строки.
opt.breakindent = true
opt.breakindentopt = 'sbr'
opt.showbreak = fn.nr2char(8618)..' '

-- Заголовок окна.
opt.title = true
opt.titlestring = '%t%( %M%)%( (%{expand("%:~:.:h")})%)%( %a%)'

-- Провайдеры Python.
g.loaded_python_provider = 0
if fn.empty(fn.glob(fn.expand('~/.pyenv/virtualenvs/pynvim/bin/python3'))) == 0 then
  g.python3_host_prog =  '~/.pyenv/virtualenvs/pynvim/bin/python3'
else
  g.loaded_python3_provider = 0
end

-- Отключение неиспользуемых встроенных модулей.
local disabled_built_ins = {
  'gzip',
  'man',
  'matchit',
  'matchparen',
  'netrwPlugin',
  'shada_plugin',
  'tar',
  'tarPlugin',
  'zip',
  'zipPlugin',
}

for i = 1, 10 do
  g['loaded_' .. disabled_built_ins[i]] = 1
end

-- Автокоманлы.
autocmd('vimrc', {
	[[BufNewFile,BufRead flake8,pycodestyle setf dosini]],
	[[BufNewFile,BufRead .gitconfig.* setf gitconfig]],
	[[BufNewFile,BufRead *init*.lua nmap K <Cmd>execute "help ".expand("<cword>")<CR>]],
	[[ColorScheme * call UpdateColors()]],
	[[FileType fish setlocal cms=#\ %s]],
	[[FileType go setlocal noexpandtab]],
	[[FileType sql nmap <buffer> <Leader>= <Cmd>%!pg_format<CR>]],
	-- [[FileType html,jinja.html,htmldjango,markdown,python setlocal wrap]],
	-- [[FileType fish setlocal foldmethod=expr]],
	-- [[FileType help setlocal conceallevel=0]],
	[[FileType go,html,htmldjango,javascript,lua,markdown,yaml,vim setlocal ts=2 sw=2 sts=2]],
	[[FileType markdown setlocal fo-=l fo+=o]],
	[[FileType python setlocal dict+=~/.config/nvim/dictionary/python fo-=t fo+=ro tw=88]],
	[[InsertEnter * set cc=+1]],
	[[InsertLeave * set cc=]],
	[[VimResized * wincmd =]],
}, true)

-- FIXME: починить highlight объявления текущего keyword Tree-Sitter'ом в diff режиме
-- сейчас оно становится невидимым, т.к. цвет текста становится аналогичен его фону.
-- Аналогично с подсветокой дальнейших вхождений этого keyword, ее фон сливается с фоном диффа.
-- Как вариант – отключить подсветку keywords в tree-sitter.
vim.api.nvim_exec([[
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

function! CheckBackSpace()
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction
]], false)

-- Подсветка разделителей в конфликтах.
cmd [[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']]

-- Применение цветовой схемы терминала из base16-shell.
if fn.empty(fn.glob(fn.expand('~/.vimrc_background'))) == 0 then
    g.base16colorspace = 256
    cmd 'source ~/.vimrc_background'
end


-- Дополнение <C-L> очисткой поиска и апдейтом диффа.
map('n', '<C-L>', ':noh<C-R>=has("diff")?"<Bar>diffupdate":""<CR><CR><C-L>')

-- Переключение langmap на <C-^> и <BS>, по аналогии с <i_C-^>.
-- Смена файла по <C-H> вмето <C-^>.
map('', '', 'a')
map('', '', '')

-- Статусные сообщения в комбинации с <C-G>.
map('n', '<C-G><C-G>', '<C-G>')
map('n', '<C-G>d', '<Cmd>echo "TODO: diagnostic counters string"<CR>')
map('n', '<C-G><C-D>', '<Cmd>echo "TODO: diagnostic counters string"<CR>')
map('n', '<C-G>w', ':echo nvim_treesitter#statusline(<C-R>=&columns<CR>)<CR>')
map('n', '<C-G><C-W>', ':echo nvim_treesitter#statusline(<C-R>=&columns<CR>)<CR>')

-- Закрытие tabpage
map('n', '<C-W><S-c>', '<Cmd>tabclose<CR>')

-- Переключение по элементам списка QuickFix.
map('n', '[q', '<Cmd>cp<CR>')
map('n', ']q', '<Cmd>cn<CR>')

-- Ресайз окна по кол-ву строк.
map('n', '<C-W>0', '<Cmd>execute ":resize".line("$")<CR>')

-- Применение макроса в VISUAL.
map('x', '@', ':<C-u>call tools#execute_macro_over_visual_range()<CR>')

-- Вызов grepprg с <cword>.
map('n', '<Leader>g', '<Cmd>execute "grep ".expand("<cword>")<CR>')

-- Поиск разделитилей merge диффов.
map('n', '<Leader>c', '/\\(<\\<Bar>>\\<Bar>=\\<Bar><Bar>\\)\\{7}<CR>')

-- TODO: <Leader>q для переключения окна qf.

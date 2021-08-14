-- TODO: попытаться улучшить время запуска
--
-- https://github.com/nanotee/nvim-lua-guide
-- https://dev.to/2nit/how-to-write-neovim-plugins-in-lua-5cca
-- https://github.com/mjlbach/defaults.nvim/blob/master/init.lua
--
local execute = vim.api.nvim_command

-- Переопределение настроек по-умолчанию
-- TODO: распределить настройки так же как у меня в старом init.vim
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.autoread = true
vim.opt.timeout = false
vim.opt.expandtab = true
vim.opt.linebreak = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.joinspaces = false
vim.opt.lazyredraw = true
vim.opt.title = true
vim.opt.ruler = false
vim.opt.wrap = false

vim.opt.numberwidth = 2
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.sidescrolloff = 5
vim.opt.synmaxcol = 800
vim.opt.updatetime = 250

-- UI
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
vim.opt.concealcursor = 'nc'
vim.opt.diffopt:append 'horizontal'
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
vim.opt.guicursor:append 'a:Cursor/lCursor'
vim.opt.guifont='Iosevka Nerd Font:h14'
vim.opt.mouse = 'a'
vim.opt.shortmess:append 'c'
vim.opt.signcolumn = 'yes'
vim.opt.spelllang = 'ru_yo,en_us'
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:.:h")})%)%( %a%)'

-- IO
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.path:append '**'
vim.opt.wildignore:append '*.pyc'

-- LSP и автодополнение
vim.g.symbols_outline = {
  highlight_hovered_item = true,
  show_guides = true,
  position = 'right',
  auto_preview = true,
  show_numbers = false,
  show_relative_numbers = false,
  show_symbol_details = true,
  keymaps = {
    close = "<Esc>",
    goto_location = "<CR>",
    focus_location = "o",
    hover_symbol = "K",
    rename_symbol = "<Leader>rn",
    code_actions = "a",
  },
  lsp_blacklist = {},
}

for type, icon in pairs(require'variables'.signs) do
  local hl = 'LspDiagnosticsSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

-- vim.g.fzf_preview_window = {'up:45%', 'ctrl-/'}

-- Подсветка отступов
vim.g.indent_blankline_char_list = {'|', '¦', '┆', '┊'}
vim.g.indent_blankline_buftype_exclude = {'terminal'}
vim.g.indent_blankline_filetype_exclude = {'help', 'markdown', 'packer'}
vim.g.indent_blankline_show_first_indent_level = false
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Разбивка строки
vim.opt.breakindent = true
vim.opt.breakindentopt = 'sbr'
vim.o.showbreak = vim.fn.nr2char(8618)..' '

-- Python-провайдеры
vim.g.loaded_python_provider = 0
if vim.fn.empty(vim.fn.glob(vim.fn.expand('~/.pyenv/virtualenvs/pynvim/bin/python3'))) == 0 then
  vim.g.python3_host_prog =  '~/.pyenv/virtualenvs/pynvim/bin/python3'
else
  vim.g.loaded_python3_provider = 0
end

-- Конфигурация vim-qf
vim.g.qf_auto_resize = 1
vim.g.qf_shorten_path = 0


-- TODO: ensure filetype plugin indent is on
-- TODO: ensure syntax is on
-- if vim.fn.has('syntax') == 1 then
--     execute 'syntax enable'
-- end


-- Инициализация (и установка) плагинов
require('plugins')

-- Цветовые схемы и подсветка синтаксиса
if vim.fn.empty(vim.fn.glob(vim.fn.expand('~/.vimrc_background'))) == 0 then
    vim.g.base16colorspace = 256
    execute 'source ~/.vimrc_background'
end
vim.fn['syntax#update_colors']()

execute [[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']]


-- Маппинг клавиш
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.keymap = 'russian-jcukenmac'
vim.opt.iminsert = 0

local keymap = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode, key, result, {noremap = true, silent = true}
  )
end

keymap('n', '<Up>', '<Nop>')
keymap('n', '<Down>', '<Nop>')
keymap('n', '<Left>', '<Nop>')
keymap('n', '<Right>', '<Nop>')

keymap('c', '<M-b>', '<S-Left>')
keymap('c', '<M-f>', '<S-Right>')

keymap('n', '<C-p>', '"0p')
keymap('v', '<C-p>', '"0p')

keymap('n', '<M-p>', '"+p')
keymap('i', '<M-p>', '+')
keymap('v', '<M-p>', '"+p')
keymap('v', '<M-y>', '"+y')

keymap('', '', 'a')
keymap('', '', '')

keymap('n', '[q', '<Cmd>cp<CR>')
keymap('n', ']q', '<Cmd>cn<CR>')

keymap('n', '<C-w>0', '<Cmd>execute ":resize".line("$")<CR>')
keymap('x', '@', ':<C-u>call tools#execute_macro_over_visual_range()<CR>')

keymap('n', '<Leader><BS>', '<Cmd>echo ""<CR>')
keymap('n', '<Leader><CR>', '<Cmd>noh<CR><Cmd>echo ""<CR>')

keymap('n', '<Leader>d', '<Cmd>execute "grep ".expand("<cword>")<CR>')
keymap('n', '<Leader>k', '<Cmd>call tools#which_key()<CR>')
keymap('n', '<Leader>t', '<Cmd>TroubleToggle<CR>')
vim.api.nvim_set_keymap('n', '<Leader>q', '<Plug>(qf_qf_toggle_stay)', {})

-- Объявление команд и автокоманд для событий
vim.api.nvim_exec([[
command! -nargs=0 -complete=command HighGroup echo(synIDattr(synID(line("."), col("."), 0), "name"))

augroup vimrc
  au!

  au BufNewFile,BufRead flake8,pycodestyle setf dosini
  au BufNewFile,BufRead .gitconfig.* setf gitconfig

  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif
  au BufWritePost plugins.lua PackerCompile

  au ColorScheme * call syntax#update_colors()

  au FileType go setlocal noexpandtab
  au FileType html,jinja.html,htmldjango,markdown,python setlocal wrap

  au FileType fish setlocal foldmethod=expr
  au FileType help setlocal conceallevel=0
  au FileType html,javascript,lua,yaml,vim setlocal ts=2 sw=2 sts=2
  au FileType markdown setlocal fo-=l
  au FileType python setlocal dict+=~/.config/nvim/dictionary/python fo-=t fo+=ro tw=88

  au InsertEnter * set cc=+1
  au InsertLeave * set cc=

  au VimResized * wincmd =
augroup END
]], false)

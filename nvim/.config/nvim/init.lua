-- Checkout:
-- https://github.com/nanotee/nvim-lua-guide
-- https://oroques.dev/notes/neovim-init/
-- https://teukka.tech/luanvim.html
-- https://dev.to/2nit/how-to-write-neovim-plugins-in-lua-5cca
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
vim.opt.updatetime = 500

-- UI
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
vim.opt.concealcursor = 'nc'
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
vim.opt.guicursor:append 'a:Cursor/lCursor'
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
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
  }
)
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

-- Подсветка отступов
vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}
vim.g.indentLine_bufTypeExclude = {'terminal'}
vim.g.indentLine_fileTypeExclude = {'help', 'markdown'}
vim.g.indent_blankline_show_first_indent_level = false
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Разбивка строки
vim.opt.breakindent = true
vim.opt.breakindentopt = 'sbr'
vim.g.showbreak = vim.fn.nr2char(8618)..' '

-- Отключение python провайдеров.
-- Иначе, без python_host_*, инициализация долгая.
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

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local key_map = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode, key, result, {noremap = true, silent = true}
  )
end

--[[ function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true}) ]]

key_map('n', '<Up>', '<Nop>')
key_map('n', '<Down>', '<Nop>')
key_map('n', '<Left>', '<Nop>')
key_map('n', '<Right>', '<Nop>')

key_map('c', '<M-b>', '<S-Left>')
key_map('c', '<M-f>', '<S-Right>')

key_map('n', '<C-p>', '"0p')
key_map('v', '<C-p>', '"0p')

key_map('n', '<M-p>', '"+p')
key_map('i', '<M-p>', '+')
key_map('v', '<M-p>', '"+p')
key_map('v', '<M-y>', '"+y')

key_map('', '', 'a')
key_map('', '', '')

key_map('n', '[q', '<Cmd>cp<CR>')
key_map('n', ']q', '<Cmd>cn<CR>')

key_map('n', 'gp', '<Cmd>execute "grep ".expand("<cword>")<CR>')
key_map('n', '<C-w>0', '<Cmd>execute ":resize".line("$")<CR>')
key_map('x', '@', ':<C-u>call tools#execute_macro_over_visual_range()<CR>')

key_map('n', '<Leader><BS>', '<Cmd>echo ""<CR>')
key_map('n', '<Leader><CR>', '<Cmd>noh<CR><Cmd>echo ""<CR>')

key_map('n', '<Leader>b', '<Cmd>Buffers<CR>')
key_map('n', '<Leader>e', '<Cmd>History<CR>')
key_map('n', '<Leader>f', '<Cmd>Files<CR>')
key_map('n', '<Leader>k', '<Cmd>call tools#which_key()<CR>')
key_map('n', '<Leader>o', '<Cmd>DocumentSymbols<CR>')
key_map('n', '<Leader>p', '<Cmd>BTags<CR>')
key_map('n', '<Leader>t', '<Cmd>TroubleToggle<CR>')
vim.api.nvim_set_keymap('n', '<Leader>q', '<Plug>(qf_qf_toggle_stay)', {})

-- Объявление команд и автокоманд для событий
vim.api.nvim_exec([[
command! -nargs=0 GitGutterMergeBase let g:gitgutter_diff_base=systemlist("git merge-base develop HEAD")[0] | GitGutter
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
  au FileType html,javascript,lua,yaml,vim setlocal tabstop=2
  au FileType html,javascript,lua,yaml,vim setlocal shiftwidth=2
  au FileType html,javascript,lua,yaml,vim setlocal softtabstop=2
  au FileType markdown setlocal fo-=l
  au FileType python setlocal dict+=~/.config/nvim/dictionary/python fo-=t fo+=ro tw=88

  au InsertEnter * set colorcolumn=89
  au InsertLeave * set colorcolumn=

  au VimResized * wincmd =
augroup END
]], false)

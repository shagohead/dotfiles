-- checkout https://github.com/rockerBOO/awesome-neovim
local execute = vim.api.nvim_command

local packer_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  print('Cloning packer.nvim ..')
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path})
  execute 'packadd packer.nvim'
  -- FIXME: sync and install
end

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Подсветка синтаксиса TreeSitter'ом
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'fish',
          'go',
          'gomod',
          'lua',
          'python',
          'rust',
          'toml',
          'yaml',
        },
        highlight = {
          enable = true,
        },
        refactor = {
          highlight_definitions = {
            enable = true,
          },
          navigation = {
            enable = true,
            keymaps = {
              goto_definition = 'gKn',
              goto_next_usage = ']k',
              goto_previous_usage = '[k',
              list_definitions = 'gKl',
              list_definitions_toc = 'gKo',
            },
          },
        },
      }
    end,
    requires = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'romgrk/nvim-treesitter-context',
    }
  }

  -- Цветовые схемы base16
  use 'chriskempson/base16-vim'

  -- Иконки nerd-fonts
  use 'kyazdani42/nvim-web-devicons'

  -- Окна с селекторами на fzf
  use '/usr/local/opt/fzf'
  use 'junegunn/fzf.vim'

  -- Хоткеи для комментирования
  use 'b3nj5m1n/kommentary'

  -- Хоткей s и S для двухбуквенных движений наподобии f и F
  use 'justinmk/vim-sneak'

  -- Команды для работы с файлами
  use 'tpope/vim-eunuch'

  -- Парные хоткеи, использующие квадратные скобки
  use 'tpope/vim-unimpaired'

  -- Хоткеи обертывания текстовых объектов (скобками)
  use 'tpope/vim-surround'

  -- Подсветка при указании диапазона строк в командном режиме
  use {
    'winston0410/range-highlight.nvim',
    config = function() require'range-highlight'.setup{} end,
    requires = {'winston0410/cmd-parser.nvim'}
  }

  -- Отображение отступов
  use 'lukas-reineke/indent-blankline.nvim'

  -- Провайдер для конфигурации статусной строки
  use {
    'glepnir/galaxyline.nvim',
    config = function() require 'statusline' end,
    branch = 'main',
  }

  -- Команды, хоткеи и автокоманды для списка quickfix
  use 'romainl/vim-qf'

  -- TODO: lazy load on attach
  -- LSP
  -- + https://github.com/ray-x/navigator.lua
  -- + https://github.com/glepnir/lspsaga.nvim
  -- + https://github.com/nvim-telescope/telescope.nvim#treesitter-picker
  -- + https://github.com/folke/lsp-colors.nvim
  -- Дерево символов текущего документа
  use 'simrat39/symbols-outline.nvim'
  -- Пиктограммы для меню автодополнения
  use {'onsails/lspkind-nvim', config = function() require'lspkind'.init() end}
  -- FZF селекторы для LSP
  use {'gfanto/fzf-lsp.nvim', config = function() require'fzf_lsp'.setup() end}
  -- Симпотишные списки диагностических сообщений и quickfix/location list
  use {'folke/trouble.nvim', config = function()
    require'trouble'.setup {
      mode = "lsp_document_diagnostics"
    }
  end}
  use {'hrsh7th/nvim-compe', config = function()
    require'compe'.setup {
      enabled = true;
      autocomplete = true;
      debug = false;
      min_length = 1;
      preselect = 'enable';
      throttle_time = 80;
      source_timeout = 200;
      incomplete_delay = 400;
      max_abbr_width = 100;
      max_kind_width = 100;
      max_menu_width = 100;
      --[[ documentation = {
        border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        max_width = 120,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
      }; ]]
      documentation = true;

      source = {
        path = true;
        buffer = true;
        nvim_lsp = true;
        nvim_lua = true;
      };
    }

    local t = function(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
      local col = vim.fn.col('.') - 1
      if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
      else
        return false
      end
    end

    -- Use (s-)tab to:
    --- move to prev/next item in completion menuone
    --- jump to prev/next snippet's placeholder
    _G.tab_complete = function()
      if vim.fn.pumvisible() == 1 then
        return t'<C-n>'
      elseif check_back_space() then
        return t'<Tab>'
      else
        return vim.fn['compe#complete']()
      end
    end
    _G.s_tab_complete = function()
      if vim.fn.pumvisible() == 1 then
        return t'<C-p>'
      else
        return t'<S-Tab>'
      end
    end

    vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
    vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
    vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
    vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
    vim.api.nvim_set_keymap('i', '<C-e>', 'compe#close("<C-e>")', {expr = true})
    vim.api.nvim_set_keymap('i', '<CR>', 'compe#confirm("<CR>")', {expr = true})
    --[[ vim.api.nvim_set_keymap('i', '<C-y>', 'compe#confirm("<C-y>")', {expr = true})
    vim.api.nvim_set_keymap('i', '<CR>', '<C-y>', {}) ]]

    -- vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', {expr = true})
  end}
  use {'neovim/nvim-lspconfig', config = function()
    --[[ lsp_status.config {
      current_function=false,
      indicator_hint='',
    } ]]

    --[[ local progress_handler = function(_, _, msg, client_id)
      lsp_status_messaging.progress_callback(_, _, msg, client_id)
      print(lsp_status.status_progress())
    end

    vim.lsp.handlers['$/progress'] = progress_handler ]]

    local on_attach = function(client, bufnr)
      print('Attaching to '..client.name)

      local key_map = function(mode, key, result)
        vim.api.nvim_buf_set_keymap(
          bufnr, mode, key, result, {noremap = true, silent = true}
        )
      end

      key_map('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
      key_map('i', '<C-y>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
      key_map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
      key_map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
      key_map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
      key_map('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
      key_map('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
      key_map('n', 'gR', '<Cmd>Trouble lsp_references<cr>')
      key_map('n', '[w', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
      key_map('n', ']w', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
      key_map('n', '<space>d', '<Cmd>execute "WorkspaceSymbols ".expand("<cword>")<CR>')
      key_map('n', '<space>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>')
      key_map('n', '<space>l', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
      key_map('n', '<space>w', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
      key_map('n', '<space>Wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
      key_map('n', '<space>Wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
      key_map('n', '<space>Wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
      key_map('n', '<space>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>')
      key_map('n', '<space>i', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
      key_map('x', '<space>i', '<Cmd>lua vim.lsp.buf.range_code_action()<CR>')
      key_map('n', '<space>=', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
    end

    -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
    local lspconfig = require'lspconfig'
    local lsp_util = require'lspconfig/util'
    local servers = {'bashls', 'dockerls', 'gopls', 'vimls'}
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup{on_attach = on_attach}
    end

    lspconfig.pyright.setup{
      on_attach = on_attach;
      --[[ root_dir = function(filename)
        -- FIXME: correct root for knowflow/service/api
        local unpacked = unpack(root_files)
        vim.g.temp_unpacked = unpacked
        local root_pattern = lsp_util.root_pattern(unpacked)(filename)
        vim.g.temp_rootpattern = root_pattern
        return root_pattern or lsp_util.path.dirname(filename)
      end, ]]
      on_init = function(client)
        -- Окружение я всегда создаю в .venv, так что..
        local pythonPath = client.config.root_dir .. '/.venv/bin/python'
        if vim.loop.fs_stat(pythonPath) then
          client.config.settings.python.pythonPath = pythonPath
          client.notify('workspace/didChangeConfiguration')
        end
        return true
      end
    }
  end}

  -- Git
  use {'tpope/vim-fugitive', cmd = {'G', 'Git', 'Gdiffsplit', 'Gw', 'Gwq'}}
  use {'airblade/vim-gitgutter', opt = true, cmd = {'GitGutter'}}

  -- Подсветка цветов для некоторых типов файлов
  use {
    'norcalli/nvim-colorizer.lua',
    opt = true, ft = {'css', 'html', 'lua'},
    config = function() require'colorizer'.setup() end
  }

  -- ?
  use {'liuchengxu/vim-which-key', opt = true, cmd = {'WhichKey'}}
  use {'luochen1990/rainbow', opt = true, cmd = {'RainbowToggle'}}

  -- .fish
  use {'dag/vim-fish', opt = true, ft = {'fish'}}

  -- .md
  use {'plasticboy/vim-markdown', opt = true, ft = {'markdown'}}

  -- .ino
  use {'sudar/vim-arduino-syntax', opt = true, ft = {'ino'}}

  -- .py
  use {'psf/black', opt = true, branch = 'main', ft = {'python'}}
  use {'Vimjas/vim-python-pep8-indent', opt = true, ft = {'python'}}

  -- .toml
  use {'cespare/vim-toml', ft = {'toml'}}

  -- nginx .conf
  -- use {'chr4/nginx.vim', opt = true, ft = {''}}
end)

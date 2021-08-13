-- https://github.com/rockerBOO/awesome-neovim
-- https://github.com/windwp/nvim-autopairs
-- https://github.com/ray-x/navigator.lua
-- https://github.com/sindrets/diffview.nvim
--
-- Добавлить плагин lsp signature, чтобы поменьшей мере получать
-- докстринг в методам и типам при автодополнении.
--
-- Debugger:
-- https://puremourning.github.io/vimspector-web/
-- https://github.com/puremourning/vimspector
-- https://github.com/nvim-telescope/telescope-vimspector.nvim
--
-- Debug Python:
-- https://github.com/puremourning/vimspector/blob/master/README.md#python
-- https://github.com/microsoft/debugpy
--
-- DAP (Debug Adapter Protocol):
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui
--
-- Snippets:
-- https://github.com/neovim/nvim-lspconfig/wiki/Snippets
-- https://github.com/L3MON4D3/LuaSnip
-- https://github.com/SirVer/ultisnips
-- https://github.com/fhill2/telescope-ultisnips.nvim
--
-- Testing:
-- https://github.com/rcarriga/vim-ultest
-- https://github.com/vim-test/vim-test

local cmd = vim.api.cmd
local packer_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  print('Cloning packer.nvim ..')
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path})
  vim.api.nvim_command 'packadd packer.nvim'
  -- FIXME: sync and install
end

return require('packer').startup({function()
  use 'wbthomason/packer.nvim'

  -- Профилирование времени запуска
  use {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = [[vim.g.startuptime_tries = 10]]
  }

  -- Подсветка синтаксиса TreeSitter'ом
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
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
  use {
    'ggandor/lightspeed.nvim',
    setup = function()
      function repeat_ft(reverse)
        local ls = require 'lightspeed'
        ls.ft['instant-repeat?'] = true
        ls.ft:to(reverse, ls.ft['prev-t-like?'])
      end
      map = require 'utils'.map
      local silent = {silent = true}
      map('n', ';', '<Cmd>Telescope grep_string<CR>')
      map('n', ';', '<Cmd>lua repeat_ft(false)<CR>', silent)
      map('x', ';', '<Cmd>lua repeat_ft(false)<CR>', silent)
      map('n', ',', '<Cmd>lua repeat_ft(true)<CR>', silent)
      map('x', ',', '<Cmd>lua repeat_ft(true)<CR>', silent)
    end,
  }

  -- Команды для работы с файлами
  use 'tpope/vim-eunuch'

  -- Парные хоткеи, использующие квадратные скобки
  use 'tpope/vim-unimpaired'

  -- Хоткеи обертывания текстовых объектов (скобками)
  use 'tpope/vim-surround'

  -- Поддержка изменения дат хоткеями <C-A>/<C-X>
  use 'tpope/vim-speeddating'

  -- Повтор последнего действия из плагинов (tpope/* и некоторых других)
  use 'tpope/vim-repeat'

  -- Подсветка при указании диапазона строк в командном режиме
  use {
    'winston0410/range-highlight.nvim',
    config = function() require 'range-highlight'.setup{} end,
    requires = {'winston0410/cmd-parser.nvim'},
  }

  -- Отображение отступов
  use 'lukas-reineke/indent-blankline.nvim'

  -- Провайдер для конфигурации статусной строки
  use {
    'glepnir/galaxyline.nvim',
    config = function() require 'statusline' end,
    branch = 'main',
  }

  -- UI с нечетким поиском, написанный на Lua
  -- checkout: https://github.com/nvim-telescope/telescope-frecency.nvim
  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    config = function()
      local actions = require 'telescope.actions'
      require 'telescope'.setup {
        defaults = {
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            }
          },
        },
        pickers = {
          buffers = {
            sort_lastused = true,
            previewer = false,
            theme = 'dropdown',
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              }
            },
          },
          find_files = {theme = 'dropdown'},
          grep_string = {theme = 'dropdown'},
          live_grep = {theme = 'dropdown'},
          oldfiles = {theme = 'dropdown'},
          treesitter = {theme = 'dropdown'},
          lsp_document_symbols = {theme = 'dropdown'},
          lsp_workspace_symbols = {theme = 'dropdown'},
        },
      }
    end,
    setup = function()
      map = require 'utils'.map
      map('n', '<Leader>d', '<Cmd>Telescope grep_string<CR>')
      map('n', '<Leader>D', '<Cmd>execute "Telescope lsp_workspace_symbols query=".expand("<cword>")<CR>')
      map('n', '<Leader>b', '<Cmd>Telescope buffers<CR>')
      map('n', '<Leader>e', '<Cmd>Telescope oldfiles<CR>')
      map('n', '<Leader>f', '<Cmd>Telescope find_files<CR>')
      map('n', '<Leader>o', '<Cmd>Telescope lsp_document_symbols<CR>')
      map('n', '<Leader>p', '<Cmd>Telescope treesitter<CR>')
    end,
  }

  use {
    'sudormrfbin/cheatsheet.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    after = 'telescope.nvim',
  }

  -- Команды, хоткеи и автокоманды для списка quickfix
  use 'romainl/vim-qf'

  -- Дерево символов текущего документа
  use 'simrat39/symbols-outline.nvim'

  -- Пиктограммы для меню автодополнения
  use {'onsails/lspkind-nvim', config = function() require 'lspkind'.init() end}

  -- Симпотишные списки диагностических сообщений и quickfix/location list
  use {'folke/trouble.nvim', config = function()
    require 'trouble'.setup {
      mode = 'lsp_document_diagnostics'
    }
  end}

  -- Автодополнение
  use {'hrsh7th/nvim-compe', config = function()
    require 'compe'.setup {
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

    local expr = {expr = true}
    vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', expr)
    vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', expr)
    vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', expr)
    vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', expr)
    vim.api.nvim_set_keymap('i', '<C-e>', 'compe#close("<C-e>")', expr)
    vim.api.nvim_set_keymap('i', '<CR>', 'compe#confirm("<CR>")', expr)
    -- vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', expr)
  end}

  -- CodeActions: https://github.com/neovim/nvim-lspconfig/wiki/Code-Actions
  -- Perf: https://github.com/neovim/nvim-lspconfig/wiki/Improving-performance
  -- Lang-spec tools: https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins
  --
  -- Конфигурация LSP клиента
  use {'neovim/nvim-lspconfig', config = function()
    local on_attach = function(client, bufnr)
      print('Attaching to '..client.name)

      local map = require 'utils'.map
      local silent = { silent = true }

      map('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
      map('i', '<C-y>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
      map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
      map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
      -- map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
      map('n', 'gD', '<Cmd>lua vim.lsp.buf.type_definition()<CR>')
      map('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
      map('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
      map('n', 'gR', '<Cmd>Trouble lsp_references<cr>')
      map('n', '[w', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
      map('n', ']w', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
      map('n', '<Leader>l', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
      map('n', '<Leader>w', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
      map('n', '<Leader>Wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
      map('n', '<Leader>Wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
      map('n', '<Leader>Wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
      map('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>')
      map('n', '<Leader>i', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
      map('x', '<Leader>i', '<Cmd>lua vim.lsp.buf.range_code_action()<CR>')
      map('n', '<Leader>=', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
      map('x', '<Leader>=', '<Cmd>lua vim.lsp.buf.formatting()<CR>')

      -- TODO: Пофиксить или удалить
      vim.api.nvim_set_keymap('n', 'Y', '<Cmd>lua v:lua.peek_definition()<CR>', {expr = true})
      local function preview_location_callback(_, _, result)
        if result == nil or vim.tbl_isempty(result) then
          return nil
        end
        vim.lsp.util.preview_location(result[1])
      end

      _G.peek_definition = function()
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
      end
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    --[[ capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'detail',
        'documentation',
        'additionalTextEdits',
      }
    } ]]

    -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
    local lspconfig = require 'lspconfig'
    local lsp_util = require 'lspconfig/util'
    local servers = {'bashls', 'dockerls', 'gopls', 'vimls'}
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup{
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end

    lspconfig.pyright.setup{
      on_attach = on_attach,
      capabilities = capabilities,
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
  use 'sindrets/diffview.nvim'
  use {
    'tpope/vim-fugitive',
    cmd = {'G', 'Git', 'Gdiffsplit', 'Gw', 'Gwq'},
    setup = function()
      map = require 'utils'.map
      map('n', '<Leader>g', '<Cmd>G<CR>')
    end,
  }
  use {'airblade/vim-gitgutter', opt = true, cmd = {'GitGutter'}}

  -- Подсветка цветов для некоторых типов файлов
  use {
    'norcalli/nvim-colorizer.lua',
    opt = true, ft = {'css', 'html', 'xhtml', 'lua'},
    config = function() require 'colorizer'.setup() end
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
end,
config = {
  display = {
    open_fn = require('packer.util').float,
  }
}})

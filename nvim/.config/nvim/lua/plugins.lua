local execute = vim.api.nvim_command

-- Подключение packer, с автоматической установкой при его отсуствии.
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
        highlight = {
          enable = true,
        }
      }
    end,
  }

  -- Цветовые схемы base16
  use 'chriskempson/base16-vim'

  -- Иконки nerd-fonts
  use 'kyazdani42/nvim-web-devicons'

  -- Окна с селекторами на fzf
  use '/usr/local/opt/fzf'
  use 'junegunn/fzf.vim'

  -- Авто-закрытие скобок
  use '9mm/vim-closer'

  -- Комментирование
  use 'b3nj5m1n/kommentary'

  -- Движение по двухбуквенным комбинациям используя s / S
  use 'justinmk/vim-sneak'

  -- Команды для работы с файлами
  use 'tpope/vim-eunuch'

  -- Хоткеи, начинающиеся с квадратных скобок [ / ]
  use 'tpope/vim-unimpaired'

  -- Обертывание текстовых объектов (скобками)
  use 'tpope/vim-surround'

  -- Highlight cmdline typing range
  use 'winston0410/cmd-parser.nvim'
  -- FIXME: didnt work anymore
  use {
    'winston0410/range-highlight.nvim',
    config = function() require'range-highlight'.setup{} end,
  }

  -- Indent lines
  use 'lukas-reineke/indent-blankline.nvim'

  use {
    'glepnir/galaxyline.nvim',
    config = function() require 'statusline' end,
    branch = 'main',
  }

  -- LSP
  -- TODO: lazy load on attach
  use 'simrat39/symbols-outline.nvim'
  use {'onsails/lspkind-nvim', config = function() require'lspkind'.init() end}
  use {'gfanto/fzf-lsp.nvim', config = function() require'fzf_lsp'.setup() end}
  use {'folke/trouble.nvim', config = function()
    require'trouble'.setup {
      mode = "lsp_document_diagnostics"
    }
  end}
  use {'neovim/nvim-lspconfig', config = function()
    local completion = require'completion'
    -- FIXME: remove lsp-status
    -- TODO: print progress messages directly
    -- TODO: configure diagnostic signs..?
    local lsp_status = require'lsp-status'
    local lsp_status_messaging = require'lsp-status/messaging'

    lsp_status.config {
      current_function=false,
      indicator_hint='',
    }

    local progress_handler = function(_, _, msg, client_id)
      lsp_status_messaging.progress_callback(_, _, msg, client_id)
      print(lsp_status.status_progress())
    end

    vim.lsp.handlers['$/progress'] = progress_handler

    local on_attach = function(client, bufnr)
      print('Attaching to '..client.name)

      local key_map = function(mode, key, result)
        vim.api.nvim_buf_set_keymap(
          bufnr, mode, key, result, {noremap = true, silent = true}
        )
      end

      --[[ buf_set_keymap('i', '<C-h>', '<Plug>(completion_next_source)', {})
      buf_set_keymap('i', '<C-l>', '<Plug>(completion_prev_source)', {}) ]]
      key_map('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
      key_map('i', '<C-y>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
      key_map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
      key_map('n', 'Y', '<Cmd>lua vim.lsp.buf.hover()<CR>')
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

      completion.on_attach(client)
      lsp_status.on_attach(client)

      -- TODO: Не дублирует ли smart_tab из init.lua?
      --[[ vim.api.nvim_buf_set_keymap(
        bufnr, 'i', '<Tab>', '<Plug>(completion_smart_tab)', {silent = true}
      )
      vim.api.nvim_buf_set_keymap(
        bufnr, 'i', '<S-Tab>', '<Plug>(completion_smart_s_tab)', {silent = true}
      ) ]]
    end

    -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
    local lspconfig = require'lspconfig'
    local servers = {'bashls', 'dockerls', 'gopls', 'vimls'}
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup{on_attach = on_attach}
    end

    lspconfig.pyright.setup{
      on_attach = on_attach;
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
  end, requires = {'nvim-lua/completion-nvim', 'nvim-lua/lsp-status.nvim'}}

  -- Git
  use {'tpope/vim-fugitive', cmd = {'Git', 'Gdiffsplit', 'Gw', 'Gwq'}}
  use {'airblade/vim-gitgutter', opt = true, cmd = {'GitGutter', 'GitGutterMergeBase'}}

  -- ?
  use {'liuchengxu/vim-which-key', opt = true, cmd = {'WhichKey'}}
  use {'luochen1990/rainbow', opt = true, cmd = {'RainbowToggle'}}

  -- .css & .html
  -- use {'../colorizer', opt = true, ft = {'css', 'html'}, config = function() require'colorizer'.setup() end}

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

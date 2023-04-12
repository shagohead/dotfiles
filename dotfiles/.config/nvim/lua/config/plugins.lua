local packer_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  print('Cloning packer.nvim ..')
  packer_repo = 'https://github.com/wbthomason/packer.nvim'
  packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', packer_repo, packer_path })
end

vim.cmd([[
augroup plugins
autocmd!
au BufWritePost plugins.lua source <afile> | PackerCompile
augroup END
]])

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'tommcdo/vim-exchange'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-commentary'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-dotenv'
  use 'tpope/vim-vinegar'
  use 'junegunn/gv.vim'
  use 'justinmk/vim-sneak'
  use 'chriskempson/base16-vim'
  use 'godlygeek/tabular'
  use 'fladson/vim-kitty'

  use {
    'junegunn/fzf',
    requires = { 'junegunn/fzf.vim' },
    config = function()
      vim.api.nvim_create_user_command(
        'Tags', 'call fzf#vim#tags(<q-args>, fzf#vim#with_preview({ '..
          '"placeholder": "--tag {2}:{-1}:{3..}", '..
          '"window": {"width": nvim_get_option("columns")-6, "height": 0.7, "yoffset": 0} '..
        '}), <bang>0)', { nargs = '*', bang = true }
      )
      vim.api.nvim_create_user_command(
        'BTags', 'call fzf#vim#buffer_tags(<q-args>, fzf#vim#with_preview({ '..
          '"placeholder": "{2}:{3..}", '..
          '"window": {"width": 0.7, "height": 0.7, "yoffset": 0} '..
        '}), <bang>0)', { nargs = '*', bang = true }
      )
      vim.keymap.set('n', '<Leader>t', '<Cmd>Tags<CR>', { silent = true })
      vim.keymap.set('n', '<Leader>]', '<Cmd>BTags<CR>', { silent = true })
      vim.api.nvim_set_var('fzf_preview_window', {'up:40%', 'ctrl-/'})
      vim.api.nvim_set_var('fzf_layout', { window = { width = 0.7, height = 0.7, yoffset = 0 } })
    end,
  }

  -- FIXME: Пока что отключен, потому как приводит к тому что в некоторых
  -- случаях создает тэги не только для файлов проекта. В частности после
  -- редактирвоания сообщения для коммита.
  --
  -- use {
  --   'ludovicchabant/vim-gutentags',
  --   -- config = function()
  --   --   vim.api.nvim_set_var('gutentags_trace', true)
  --   --   vim.api.nvim_create_autocmd({'FileType'}, {
  --   --     pattern = "python",
  --   --     callback = function(args)
  --   --       vim.api.nvim_set_var('gutentags_project_root', {'pyproject.toml', 'Pipfile', '.git'})
  --   --     end,
  --   --   })
  --   -- end,
  -- }

  use {
    'neovim/nvim-lspconfig',
    config = require 'config.lsp',
    requires = {
      { 'j-hui/fidget.nvim', config = function() require'fidget'.setup{} end },
      { 'ray-x/lsp_signature.nvim', opt = true },
      { 'folke/trouble.nvim', opt = true },
      {
        'kosayoda/nvim-lightbulb',
        config = function()
          require 'nvim-lightbulb'.setup {
            sign = { enabled = true, priority = 8 },
          }
        end
      },
    },
  }

  use {
    'hrsh7th/nvim-cmp',
    config = require 'config.completion',
    requires = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'onsails/lspkind-nvim' },
      { 'dcampos/nvim-snippy' },
      { 'dcampos/cmp-snippy' },
    },
  }

  use {
    -- TODO: Добавить для vim-dadbod-completion поддержку $DATABASE_URL
    'kristijanhusak/vim-dadbod-completion',
    requires = { 'tpope/vim-dadbod' },
    config = function()
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = "sql,mysql,plsql",
        callback = function(args)
          vim.api.nvim_buf_set_option(0, 'omnifunc', 'vim_dadbod_completion#omni')
          -- TODO: Устанавливать настройки для cmp, если он загружен
          -- require('cmp').setup.buffer({
          --   sources = {
          --     { name = 'vim-dadbod-completion', keyword_length = 2, max_item_count = 30 },
          --     { name = 'buffer', keyword_length = 3, max_item_count = 10 }
          --   }
          -- })
        end,
      })
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    after = 'gitsigns.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('config.statusline') end
  }

  use {
    'preservim/vim-markdown',
    requires = { 'godlygeek/tabular' },
    config = function()
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = "markdown",
        callback = function(args)
          -- FIXME: Удалять в FileType еще рано, а в BufWritePost вызывает повторные удаления
          -- vim.api.nvim_buf_del_keymap(0, 'n', 'ge')
          -- vim.api.nvim_set_keymap('n', '<Plug>Markdown_EditUrlUnderCursor', '', {})
        end,
      })
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    config = require 'config.telescope',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
    },
  }

  use {
    'winston0410/range-highlight.nvim',
    config = function() require 'range-highlight'.setup{} end,
    requires = { 'winston0410/cmd-parser.nvim' },
  }

  use { 'sunaku/vim-dasht', config = require 'config.dasht' }
  use { 'lewis6991/gitsigns.nvim', config = function() require'config.gitsigns' end }
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 20]] }
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'tpope/vim-characterize', keys = { 'ga' } }
  use { 'tpope/vim-eunuch', cmd = { 'Delete', 'Remove', 'Move', 'Rename', 'Mkdir', 'Mkdir!' } }
  use { 'psf/black', branch = 'main', ft = { 'python' } }
  use { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } }

  use {
    'lifepillar/pgsql.vim',
    config = function() vim.cmd([[let g:sql_type_default = 'pgsql']]) end
  }

  use {
    'dag/vim-fish', ft = { 'fish' },
    config = function()
      vim.cmd([[
      au FileType fish compiler fish
      au FileType fish setlocal foldmethod=expr
      ]])
    end
  }

  -- use {
  --   'nvim-treesitter/nvim-treesitter',
  --   opt = true, run = ':TSUpdate', ft = { 'norg' },
  --   config = function()
  --     require('nvim-treesitter.configs').setup {
  --       highlight = { enable = true },
  --       indent = { enable = true },
  --     }
  --   end,
  -- }

  -- use {
  --   'nvim-neorg/neorg',
  --   -- ft = { 'norg' },  -- FIXME: Приводит к багу, а если указать ft для nvim-treesitter, то - нет 🤷
  --   after = 'nvim-treesitter',
  --   requires = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  --   config = function()
  --       require('neorg').setup {
  --         load = { ["core.defaults"] = {} }
  --       }
  --   end,
  -- }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

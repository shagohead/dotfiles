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
    'nvim-lualine/lualine.nvim',
    -- after = 'gitsigns.nvim', FIXME: Не помогает для корректного определения файла.
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('config.statusline') end
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('config.gitsigns') end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      local actions = require 'telescope.actions'
      require 'telescope'.setup {
        defaults = {
          mappings = { i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          } },
        },
        pickers = {
          buffers = {
            previewer = false, sort_lastused = true,
            mappings = { i = { ["<C-d>"] = actions.delete_buffer } },
          },
        },
      }
    end,
    setup = function()
      vim.cmd([[
      nnoremap <Leader>b <Cmd>Telescope buffers theme=dropdown<CR>
      nnoremap <Leader>e <Cmd>Telescope oldfiles theme=dropdown<CR>
      nnoremap <Leader>f <Cmd>Telescope find_files theme=dropdown<CR>
      nnoremap <Leader>o <Cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols(require('telescope.themes').get_dropdown({layout_config={width=vim.api.nvim_get_option("columns")-6}}))<CR>
      nnoremap <Leader>p <Cmd>lua require'telescope.builtin'.lsp_document_symbols(require('telescope.themes').get_dropdown({layout_config={width=vim.api.nvim_get_option("columns")-6}}))<CR>
      ]])
    end,
  }

  use {
    'winston0410/range-highlight.nvim',
    config = function() require 'range-highlight'.setup{} end,
    requires = { 'winston0410/cmd-parser.nvim' },
  }

  use {
    'neovim/nvim-lspconfig',
    requires = {
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'onsails/lspkind-nvim' },
      { 'dcampos/nvim-snippy' },
      { 'dcampos/cmp-snippy' },
      { 'ray-x/lsp_signature.nvim', opt = true },
      { 'folke/trouble.nvim', opt = true },
      {
        'kosayoda/nvim-lightbulb',
        config = function()
          require 'nvim-lightbulb'.setup {
            sign = { enabled = true, priority = 8 },
          }
        end
      }
    },
    config = function()
      local on_attach = function(client, bufnr)
        print('Attached to '..client.name..' for buf #'..bufnr)
        vim.cmd([[
        setlocal omnifunc=v:lua.vim.lsp.omnifunc
        nnoremap <buffer> <M-k> <Cmd>lua vim.lsp.buf.signature_help()<CR>
        inoremap <buffer> <M-k> <Cmd>lua vim.lsp.buf.signature_help()<CR>
        nnoremap <buffer> K <Cmd>lua vim.lsp.buf.hover()<CR>
        nnoremap <buffer> gd <Cmd>lua vim.lsp.buf.definition()<CR>
        nnoremap <buffer> gi <Cmd>lua vim.lsp.buf.implementation()<CR>
        nnoremap <buffer> gr <Cmd>lua vim.lsp.buf.references()<CR>
        nnoremap <buffer> [w <Cmd>lua vim.diagnostic.goto_prev()<CR>
        nnoremap <buffer> ]w <Cmd>lua vim.diagnostic.goto_next()<CR>
        nnoremap <buffer> <Leader>l :Lsp
        nnoremap <buffer> <Leader>w <Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
        nnoremap <buffer> <Leader>a <Cmd>lua vim.lsp.buf.code_action()<CR>
        xnoremap <buffer> <Leader>a <Cmd>lua vim.lsp.buf.range_code_action()<CR>
        nnoremap <buffer> <Leader>= <Cmd>lua vim.lsp.buf.formatting()<CR>
        xnoremap <buffer> <Leader>= <Cmd>lua vim.lsp.buf.formatting()<CR>
        command! -nargs=0 -buffer LspRename lua vim.lsp.buf.rename()
        command! -nargs=0 -buffer LspTypeDef lua vim.lsp.buf.type_definition()
        command! -nargs=0 -buffer DiagnosticList lua vim.lsp.diagnostic.set_loclist()
        command! -nargs=0 -buffer WorkspaceAdd lua vim.lsp.buf.add_workspace_folder()
        command! -nargs=0 -buffer WorkspaceRemove lua vim.lsp.buf.remove_workspace_folder()
        command! -nargs=0 -buffer WorkspaceList lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        au CursorHold,CursorHoldI <buffer> lua require'nvim-lightbulb'.update_lightbulb()
        packadd lsp_signature.nvim
        packadd trouble.nvim
        ]])
        require 'trouble'.setup { mode = 'document_diagnostics' }
        require 'lsp_signature'.on_attach({ bind = true, hint_enable = false, handler_opts = { border = 'none' } }, bufnr)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local lspconfig = require 'lspconfig'

      for _, lsp in ipairs({
        'bashls',
        'dockerls',
        'gopls',
        'tsserver',
        'vimls'
      }) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          capabilities = capabilities
        }
      end

      lspconfig.pyright.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        on_init = function(client)
          local pythonPath = client.config.root_dir .. '/.venv/bin/python'
          if vim.loop.fs_stat(pythonPath) then
            client.config.settings.python.pythonPath = pythonPath
            client.notify('workspace/didChangeConfiguration')
          end
          return true
        end
      }

      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
      )

      local lspkind = require 'lspkind'
      local cmp = require 'cmp'

      cmp.setup({
        snippet = {
          expand = function(args)
            require 'snippy'.expand_snippet(args.body)
          end,
        },
        mapping = {
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
          ['<C-y>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
          ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          ['<Tab>'] = function(fallback)
            if cmp.visible() then cmp.select_next_item() else fallback() end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then cmp.select_prev_item() else fallback() end
          end,
        },
        sources = {
          { name = 'nvim_lsp', max_item_count = 20 },
          { name = 'buffer', keyword_length = 3, max_item_count = 10 },
          { name = 'snippy', max_item_count = 10 },
        },
        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol', with_text = true,
            menu = { nvim_lsp = 'lsp', buffer = 'buf' }
          }
        },
      })

      vim.cmd([[
      augroup completion
      autocmd!
      au FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion', keyword_length = 2, max_item_count = 30 }, { name = 'buffer', keyword_length = 3, max_item_count = 10 }} })
      augroup END
      ]])
    end,
  }

  -- use {
  --   'hrsh7th/nvim-cmp',
  -- }

  use {
    'sunaku/vim-dasht',
    config = function()
      vim.cmd([[
      nnoremap <silent> <Leader>K :call Dasht(dasht#cursor_search_terms())<CR>
      nnoremap <silent> <Leader><Leader>K :call Dasht(dasht#cursor_search_terms(), '!')<CR>
      vnoremap <silent> <Leader>K y:<C-U>call Dasht(getreg(0))<CR>
      vnoremap <silent> <Leader><Leader>K y:<C-U>call Dasht(getreg(0), '!')<CR>
      let g:dasht_filetype_docsets = {}
      let g:dasht_filetype_docsets['sh'] = ['Bash']
      let g:dasht_filetype_docsets['go'] = ['Go']
      let g:dasht_filetype_docsets['python'] = ['Python_3']
      let g:dasht_filetype_docsets['sql'] = ['PostgreSQL']
      ]])
    end,
  }

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

  use {
    'nvim-treesitter/nvim-treesitter',
    opt = true,
    run = ':TSUpdate',
    ft = { 'norg' },
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {enable = true},
        indent = {enable = true},
      }
    end,
  }

  use {
    'nvim-neorg/neorg',
    -- ft = { 'norg' },  -- FIXME: Приводит к багу, а если указать ft для nvim-treesitter, то - нет 🤷
    after = 'nvim-treesitter',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        require('neorg').setup {
          load = {
            ["core.defaults"] = {}
          }
        }
    end,
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

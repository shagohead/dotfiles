-- https://github.com/justinmk/config/blob/master/.config/nvim/lua/plugins.lua
-- https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/lua/plugins.lua
-- https://www.youtube.com/watch?v=_DnmphIwnjo [nvim-cmp & dadbot & other?]
-- https://github.com/rockerBOO/awesome-neovim

-- Алиасы интерфейса к объектам vim.
local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
local opt = vim.opt
local o, wo, bo = vim.o, vim.wo, vim.bo
local map = require 'utils'.map

-- Автоустановка packer.nvim.
local packer_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
  print('Cloning packer.nvim ..')
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path})
  -- FIXME: sync and install
	cmd 'packadd packer.nvim'
	cmd 'PackerUpdate'
end

return require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'airblade/vim-gitgutter'
  use 'justinmk/vim-sneak' -- Lua альтернатива: 'ggandor/lightspeed.nvim'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-unimpaired'
	use 'tpope/vim-commentary' -- Lua альтернатива: 'b3nj5m1n/kommentary'
	use 'tpope/vim-speeddating'
	use 'tpope/vim-surround'
	use 'tpope/vim-repeat'
	use 'tpope/vim-dadbod'
	use 'junegunn/gv.vim'
	use 'chriskempson/base16-vim'
	-- use 'simnalamburt/vim-mundo'
	
	-- Селектор с нечетким поиском.
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
          lsp_references = {theme = 'dropdown'},
          lsp_document_symbols = {theme = 'dropdown'},
          lsp_workspace_symbols = {theme = 'dropdown'},
        },
      }
    end,
    setup = function()
      map = require 'utils'.map
      -- map('n', 'gR', '<Cmd>Telescope lsp_references<CR>')
      map('n', '<Leader>G', '<Cmd>Telescope grep_string<CR>')
      map('n', '<Leader>b', '<Cmd>Telescope buffers<CR>')
      map('n', '<Leader>e', '<Cmd>Telescope oldfiles<CR>')
      map('n', '<Leader>f', '<Cmd>Telescope find_files<CR>')
      map('n', '<Leader>p', '<Cmd>Telescope treesitter<CR>')
      map('n', '<Leader>o', '<Cmd>Telescope lsp_document_symbols<CR>')
      map('n', '<Leader>O', '<Cmd>execute "Telescope lsp_workspace_symbols query=".expand("<cword>")<CR>')
    end,
  }

  use {
    'winston0410/range-highlight.nvim',
    config = function() require 'range-highlight'.setup{} end,
    requires = {'winston0410/cmd-parser.nvim'},
  }

  use {
		'neovim/nvim-lspconfig',
		requires = {
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-vsnip'},
			{'hrsh7th/vim-vsnip'},
			{'onsails/lspkind-nvim'},
			{'kristijanhusak/vim-dadbod-completion'},  -- Lazy-load
			{'folke/trouble.nvim', opt = true},
		},
		config = function()
			local on_attach = function(client, bufnr)
				print('Attached to '..client.name)
				-- TODO: set new hover() mapping, release K for keywordprg
				vim.cmd([[
					setlocal signcolumn=yes
					nnoremap <buffer> <C-k> <Cmd>lua vim.lsp.buf.signature_help()<CR>
					inoremap <buffer> <C-y> <Cmd>lua vim.lsp.buf.signature_help()<CR>
					nnoremap <buffer> K <Cmd>lua vim.lsp.buf.hover()<CR>
					nnoremap <buffer> gd <Cmd>lua vim.lsp.buf.definition()<CR>
					nnoremap <buffer> gi <Cmd>lua vim.lsp.buf.implementation()<CR>
					nnoremap <buffer> gr <Cmd>lua vim.lsp.buf.references()<CR>
					nnoremap <buffer> [w <Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
					nnoremap <buffer> ]w <Cmd>lua vim.lsp.diagnostic.goto_next()<CR>
					nnoremap <buffer> <Leader>l <Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
					nnoremap <buffer> <Leader>w <Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
					nnoremap <buffer> <Leader>rn <Cmd>lua vim.lsp.buf.rename()<CR>
					nnoremap <buffer> <Leader>a <Cmd>lua vim.lsp.buf.code_action()<CR>
					xnoremap <buffer> <Leader>a <Cmd>lua vim.lsp.buf.range_code_action()<CR>
					nnoremap <buffer> <Leader>= <Cmd>lua vim.lsp.buf.formatting()<CR>
					xnoremap <buffer> <Leader>= <Cmd>lua vim.lsp.buf.formatting()<CR>

					command! -nargs=0 WorkspaceAdd lua vim.lsp.buf.add_workspace_folder()
					command! -nargs=0 WorkspaceRemove lua vim.lsp.buf.remove_workspace_folder()
					command! -nargs=0 WorkspaceList lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))

					packadd trouble.nvim
					nnoremap <buffer> <Leader>t <Cmd>TroubleToggle<CR>
				]])


				require 'trouble'.setup {mode = 'lsp_document_diagnostics'}
				-- map('n', 'gr', '<Cmd>Trouble lsp_references<cr>')
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

			local lspconfig = require 'lspconfig'
			local lsp_util = require 'lspconfig/util'
			local servers = {'bashls', 'dockerls', 'gopls', 'vimls'}
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup{ on_attach = on_attach, capabilities = capabilities }
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

			-- require 'lspkind'.init()
			local lspkind = require 'lspkind'
			local cmp = require 'cmp'
			cmp.setup({
				mapping = {
					-- ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					-- ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<Tab>'] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						-- elseif vim.fn['CheckBackSpace']() == 0 then
						-- 	cmp.complete()
						else
							fallback()
						end
					end,
					['<S-Tab>'] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
						-- elseif vim.fn['CheckBackSpace']() == 0 then
						-- 	cmp.complete()
						else
							fallback()
						end
					end,
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.close(),
					['<C-y>'] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
					['<CR>'] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'vsnip' },
					{ name = 'buffer' },
				},
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				formatting = {
					format = lspkind.cmp_format {
						with_text = true,
						menu = {
							buffer = '[buf]',
							luasnip = '[snip]',
							nvim_lsp = '[LSP]',
							path = '[path]',
						}
					}
				},
			})

      local autocmd = require 'utils'.autocmd
			autocmd('Completion', {[[FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })]]})
		end,
	}

	use 'kyazdani42/nvim-web-devicons'

	treesitter_ft = {
		'bash',
		'fish',
		'go',
		'gomod',
		'lua',
		'python',
		'rust',
		'toml',
		'yaml',
	}
  use {
    'nvim-treesitter/nvim-treesitter',
		requires = {
			'nvim-treesitter/nvim-treesitter-refactor',
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		opt = true,
		ft = treesitter_ft,
    run = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = treesitter_ft,
        highlight = {
          enable = true,
					-- custom_captures = {
					-- 	['FIXME.group'] = 'Identifier',
					-- },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gss',
            node_selection = 'gsn',
            node_decremental = '-',
            node_incremental = '+',
            scope_incremental = 'gss',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['am'] = '@function.outer',
              ['im'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
					-- FIXME configure: move, swap (arguments ;)
					-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-swap
          __move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
        },
        refactor = {
          highlight_definitions = { enable = true },
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
  }

  use {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = [[vim.g.startuptime_tries = 10]]
  }

	use {
		'tpope/vim-eunuch',
		cmd = {'Delete', 'Remove', 'Move', 'Rename', 'Mkdir', 'Mkdir!'}
	}

	use {'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim'}

  -- .py
  use {'psf/black', branch = 'main', ft = {'python'}}
  use {'Vimjas/vim-python-pep8-indent', ft = {'python'}}
end)

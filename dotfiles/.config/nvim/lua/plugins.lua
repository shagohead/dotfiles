-- Установка менеджера пакетов (packer.nvim).
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
	use 'tpope/vim-dadbod'
	use 'junegunn/gv.vim'
	use 'chriskempson/base16-vim'

	-- TODO: add norcalli/nvim-colorizer.lua for css/js

	use 'ggandor/lightspeed.nvim'
	-- sneak чуть быстрее грузится, зато lightspeed быстрее в использовании
	-- use 'justinmk/vim-sneak'

	-- use 'haya14busa/is.vim'

	-- use 'chr4/nginx.vim'
	--
	-- use 'wellle/targets.vim'

	use {
		'nvim-lualine/lualine.nvim',
		-- TODO: lock / modified / etc status as icons
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			local cterm_theme = {
				inactive = { c = { fg = 7, bg = 18 } },
				normal = {
					a = { fg = 18, bg = 4, gui = 'bold' },
					b = { fg = 7, bg = 18 },
					c = { fg = 7, bg = 19 },
				},
				visual = { a = { fg = 18, bg = 5, gui = 'bold' } },
				replace = { a = { fg = 18, bg = 17, gui = 'bold' } },
				insert = { a = { fg = 18, bg = 2, gui = 'bold' } },
				command = { a = { fg = 18, bg = 1, gui = 'bold'} },
			}
			require('lualine').setup {
				options = {
					theme = cterm_theme,
					component_separators = {
						left = "〉", right = "〈"
					},
				},
				sections = {
					lualine_a = {
						{
							function()
								if vim.bo.iminsert == 0 then
									return ''
								else
									return ' ' .. vim.b.keymap_name .. ' '
								end
							end,
							color = { fg = 1, bg = 0 },
							separator = {}, padding = 0,
						},
						'mode',
					},
					lualine_b = {'branch', 'diff', { 'diagnostics', sources = { 'nvim_diagnostic' }, } },
					lualine_c = { 'filename' },
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				},
			}
		end
	}

	use {
		'airblade/vim-gitgutter', -- Lua: lewis6991/gitsigns.nvim
		config = function()
			vim.cmd([[
				let g:gitgutter_enabled = 0
				let g:gitgutter_sign_priority = 9
				let g:gitgutter_highlight_lines = 1
				let g:gitgutter_highlight_linenrs = 1
				" let g:gitgutter_preview_win_floating = 0 // fix error on open preview win
				" 'couse i don't like popups
				let g:gitgutter_floating_window_options = {
        \ 'relative': 'cursor',
        \ 'row': 1,
        \ 'col': 0,
        \ 'width': 42,
        \ 'height': &previewheight,
        \ 'style': 'minimal',
				\ 'border': 'rounded'
        \ }
				nmap <Leader>ht <Cmd>GitGutterBufferToggle<CR>
				nmap <Leader>hl <Cmd>GitGutterLineHighlightsToggle<CR>
				command! -nargs=0 DiffBaseSet let g:gitgutter_diff_base = $DIFF_BASE

				if len($DIFF_BASE)
					let g:gitgutter_diff_base = $DIFF_BASE
				endif
			]])
		end
	}
	
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
			'nvim-lua/popup.nvim',
			'nvim-lua/plenary.nvim',
			{ 'kyazdani42/nvim-web-devicons', opt = true },
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
            previewer = false,
            sort_lastused = true,
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
				nnoremap <Leader>p <Cmd>Telescope treesitter theme=dropdown<CR>
				nnoremap <Leader>o <Cmd>Telescope lsp_document_symbols theme=dropdown<CR>

				command! -nargs=0 ScopeRef Telescope lsp_references theme=dropdown
				command! -nargs=0 ScopeGrep Telescope grep_string theme=dropdown
				command! -nargs=0 ScopeSymol execute "Telescope lsp_workspace_symbols theme=ivy query=".expand("<cword>")
			]])
    end,
  }

	-- Подсветка области кода, попадающей в range командной строки.
  use {
    'winston0410/range-highlight.nvim',
    config = function() require 'range-highlight'.setup{} end,
    requires = { 'winston0410/cmd-parser.nvim' },
  }

	-- Конфигурация LSP, для поддерживающих его буфферов.
  use {
		'neovim/nvim-lspconfig',
		requires = {
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-vsnip' },
			{ 'hrsh7th/vim-vsnip' },
			{ 'rafamadriz/friendly-snippets' },
			{ 'onsails/lspkind-nvim' },
			{ 'kristijanhusak/vim-dadbod-completion' },
			{ 'ray-x/lsp_signature.nvim', opt = true },
			{ 'stevearc/aerial.nvim', opt = true },
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
			-- Конфигурация для буфферов, поддерживающих lsp.
			local on_attach = function(client, bufnr)
				print('Attached to '..client.name)
				vim.cmd([[
					setlocal signcolumn=yes
					setlocal omnifunc=v:lua.vim.lsp.omnifunc
					nnoremap <buffer> <C-k> <Cmd>lua vim.lsp.buf.signature_help()<CR>
					inoremap <buffer> <C-y> <Cmd>lua vim.lsp.buf.signature_help()<CR>
					nnoremap <buffer> K <Cmd>lua vim.lsp.buf.hover()<CR>
					nnoremap <buffer> gd <Cmd>lua vim.lsp.buf.definition()<CR>
					nnoremap <buffer> gi <Cmd>lua vim.lsp.buf.implementation()<CR>
					nnoremap <buffer> gr <Cmd>lua vim.lsp.buf.references()<CR>
					nnoremap <buffer> [w <Cmd>lua vim.diagnostic.goto_prev()<CR>
					nnoremap <buffer> ]w <Cmd>lua vim.diagnostic.goto_next()<CR>
					nnoremap <buffer> <Leader>l <Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
					nnoremap <buffer> <Leader>w <Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
					nnoremap <buffer> <Leader>n <Cmd>lua vim.lsp.buf.rename()<CR>
					nnoremap <buffer> <Leader>a <Cmd>lua vim.lsp.buf.code_action()<CR>
					xnoremap <buffer> <Leader>a <Cmd>lua vim.lsp.buf.range_code_action()<CR>
					nnoremap <buffer> <Leader>= <Cmd>lua vim.lsp.buf.formatting()<CR>
					xnoremap <buffer> <Leader>= <Cmd>lua vim.lsp.buf.formatting()<CR>

					command! -nargs=0 WorkspaceAdd lua vim.lsp.buf.add_workspace_folder()
					command! -nargs=0 WorkspaceRemove lua vim.lsp.buf.remove_workspace_folder()
					command! -nargs=0 WorkspaceList lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))

					packadd aerial.nvim
					packadd lsp_signature.nvim
					packadd trouble.nvim

					nnoremap <buffer> <Leader>t <Cmd>TroubleToggle<CR>
					nnoremap <buffer> <Leader>r <Cmd>Trouble lsp_references<CR>

					augroup lightbulb
					autocmd!
					" FIXME: сомнительно работает
					au CursorHold,CursorHoldI <buffer> lua require'nvim-lightbulb'.update_lightbulb()
					augroup END
				]])

				require 'aerial'.on_attach(client, bufnr)
				require 'lsp_signature'.on_attach(client, bufnr)
				require 'trouble'.setup { mode = 'document_diagnostics' }
			end

			-- Возможности клиента nvim-cmp для lsp.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

			-- Конфигурация lsp серверов.
			local lspconfig = require 'lspconfig'
			local servers = { 'bashls', 'dockerls', 'gopls', 'vimls' }
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup { on_attach = on_attach, capabilities = capabilities }
			end

			-- Поддержка venv для LSP сервера Python.
			-- local lsp_util = require 'lspconfig/util'
			lspconfig.pyright.setup {
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

			-- Переопределение настроек публикации диагностики.
			vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
				vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
			)

			-- Автодополнение.
			local feedkey = function(key, mode)
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
			end
			local lspkind = require 'lspkind'
			local cmp = require 'cmp'

			cmp.setup({
				mapping = {
					['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
					['<C-e>'] = cmp.mapping(
						{ i = cmp.mapping.abort(), c = cmp.mapping.close() }
					),
					['<C-y>'] = cmp.mapping.confirm(
						{ behavior = cmp.ConfirmBehavior.Insert, select = false }
						),
					['<CR>'] = cmp.mapping.confirm(
						{ behavior = cmp.ConfirmBehavior.Replace, select = true }
					),
					['<Tab>'] = function(fallback)
						if cmp.visible() then 
							cmp.select_next_item()
						-- elseif vim.fn["vsnip#available"](1) == 1 then
						-- 	feedkey('<Plug>(vsnip-expand-or-jump)', '')
						else
							fallback()
						end
					end,
					['<S-Tab>'] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						-- elseif vim.fn["vsnip#available"](-1) == 1 then
						-- 	feedkey('<Plug>(vsnip-jump-prev)', '')
						else
							fallback()
						end
					end,
					['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
					['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'vsnip' },
					{ name = 'buffer', keyword_length = 5, max_item_count = 10 },
				},
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				formatting = {
					format = lspkind.cmp_format {
						mode = 'symbol',
						with_text = true,
						menu = {
							nvim_lsp = 'lsp',
							buffer = 'buf',
							vsnip = 'snip',
						}
					}
				},
			})

			vim.cmd([[
				augroup completion
				autocmd!
				au FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
				augroup END

				nnoremap <C-G>d <Cmd>echo "TODO: diagnostic counters string"<CR>
				nnoremap <C-G><C-D> <Cmd>echo "TODO: diagnostic counters string"<CR>
			]])
		end,
	}

	-- TreeSitter, запускаемый для определенных типов файлов.
	treesitter_ft = {
		'bash',
		'fish',
		'go',
		'gomod',
		'javascript',
		'lua',
		'make',
		'markdown',
		'python',
		'rust',
		'toml',
		'vim',
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
				sync_install = true,
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gs',
            node_decremental = '-',
            node_incremental = '+',
            scope_incremental = 'gs',
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
					swap = {
						enable = true,
						swap_next = {["<Leader>s"] = "@parameter.inner"},
						swap_previous = {["<Leader>S"] = "@parameter.inner"},
					},
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {[']m'] = '@function.outer', [']]'] = '@class.outer'},
            goto_next_end = {[']M'] = '@function.outer', [']['] = '@class.outer'},
            goto_previous_start = {['[m'] = '@function.outer', ['[['] = '@class.outer'},
            goto_previous_end = {['[M'] = '@function.outer', ['[]'] = '@class.outer'},
          },
        },
        refactor = {
          highlight_definitions = {
						enable = true,
						clear_on_cursor_move = false,
					},
          navigation = {
            enable = true,
            keymaps = {
              goto_next_usage = ']l',
              goto_previous_usage = '[l',
              goto_definition = '<Nop>',
							list_definitions = '<Nop>',
              list_definitions_toc = '<Nop>',
            },
          },
        },
      }
			vim.cmd([[
				nnoremap <C-G>w :echo nvim_treesitter#statusline(<C-R>=&columns<CR>)<CR>
				nnoremap <C-G><C-W> :echo nvim_treesitter#statusline(<C-R>=&columns<CR>)<CR>
			]])
    end,
  }

	-- Дебаггер.
	-- use {
	-- 	{
	-- 		'mfussenegger/nvim-dap',
	-- 		setup = [[require('config.dap_setup')]],
	-- 		config = [[require('config.dap')]],
	-- 		requires = 'jbyuki/one-small-step-for-vimkind',
	-- 		wants = 'one-small-step-for-vimkind',
	-- 		module = 'dap',
	-- 	},
	-- 	{
	-- 		'rcarriga/nvim-dap-ui',
	-- 		requires = 'nvim-dap',
	-- 		after = 'nvim-dap',
	-- 		config = function()
	-- 			require('dapui').setup()
	-- 		end,
	-- 	},
	-- }
	-- VIM " Run the `configurations` picker from nvim-dap
	-- :Telescope dap configurations
	-- LUA -- Run the `configurations` picker from nvim-dap
	-- require('telescope').extensions.dap.configurations()
	-- https://github.com/leoluz/nvim-dap-go

	-- Подсветка TODO/FIXME/и т.д.
	-- TODO: вместо объявлений hl group форком репы заменить код на cterm
	-- FIXME: ошибка в nvim при возврате комментария по <C-r>
	use {
		'folke/todo-comments.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require("todo-comments").setup {
				signs = false,
				sign_priority = 7,
			}

			-- Мб 7 вместо 6
			vim.cmd([[
			hi TodoBgNOTE cterm=bold ctermfg=0 ctermbg=6
			hi TodoFgNOTE cterm=italic ctermfg=6
			hi TodoSignNOTE ctermfg=6

			hi TodoBgPERF cterm=bold ctermfg=7 ctermbg=1
			hi TodoFgPERF cterm=italic ctermfg=1
			hi TodoSignPERF ctermfg=1

			hi TodoBgWARN cterm=bold ctermfg=0 ctermbg=3
			hi TodoFgWARN cterm=italic ctermfg=3
			hi TodoSignWARN ctermfg=3

			hi TodoBgTODO cterm=bold ctermfg=0 ctermbg=4
			hi TodoFgTODO cterm=italic ctermfg=4
			hi TodoSignTODO ctermfg=4

			hi TodoBgFIX cterm=bold ctermfg=7 ctermbg=1
			hi TodoFgFIX cterm=italic ctermfg=1
			hi TodoSignFIX ctermfg=1

			hi TodoBgHACK cterm=bold ctermfg=0 ctermbg=3
			hi TodoFgHACK cterm=italic ctermfg=3
			hi TodoSignHACK ctermfg=3
			]])
		end
	}

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

	-- Плагины, запускаемые по команде или по хоткею.
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 20]] }
	use { 'tpope/vim-characterize', keys = { 'ga' } }
	use { 'tpope/vim-eunuch', cmd = { 'Delete', 'Remove', 'Move', 'Rename', 'Mkdir', 'Mkdir!' } }
	use {
		'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim', cmd = {
			'DiffviewClose', 'DiffviewFileHistory', 'DiffviewFocusFiles',
			'DiffviewLog', 'DiffviewRefresh', 'DiffviewToggleFiles',
		}
	}

	-- Плагины, запускаемые по типу файла.
  use { 'psf/black', branch = 'main', ft = { 'python' } }
  use { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } }

	-- Синхронизация после установки packer.nvim.
	if packer_bootstrap then
    require('packer').sync()
  end
end)

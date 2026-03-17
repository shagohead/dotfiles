-- Options below was set over defaults of nvim v0.11

-- User input
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.mouse = "a"
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.completeopt = "fuzzy,menuone,noinsert,noselect,preview"
vim.o.wildoptions = "fuzzy,pum,tagfile"

-- UI output
vim.o.wrap = false
vim.o.list = true
vim.opt.diffopt:append("vertical")
vim.opt.listchars = { tab = "  ", trail = "•", nbsp = "␣" }
vim.opt.fillchars = { diff = "/" }
vim.o.inccommand = "split"
vim.o.relativenumber = true
vim.o.showmode = false
vim.o.winborder = "rounded"
vim.o.title = true
vim.o.titlestring = "%t%( %M%)%( (%{expand(\"%:~:.:h\")})%)%( %a%)"
vim.o.foldlevelstart = 99
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.termguicolors = false
vim.api.nvim_exec2("colorscheme cterm256", {})

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = 'e',
			[vim.diagnostic.severity.WARN] = 'w',
			[vim.diagnostic.severity.INFO] = 'ℹ︎',
			[vim.diagnostic.severity.HINT] = 'h',
		},
	},
})

-- System IO
vim.o.path = ".,,**"
vim.o.wildignore = "*.pyc"
vim.o.tags = "./tags;,tags,tags_venv"
vim.o.undofile = true

-- Exrc only for trusted files
if vim.fn.has("nvim-0.9") then
	vim.o.exrc = true
end

-- Configuration helpers
local augroup = vim.api.nvim_create_augroup("init.lua", { clear = true })

---@diagnostic disable-next-line: undefined-field
local fs_stat = (vim.uv or vim.loop).fs_stat

local feedkeys = function(input, mode)
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes(input, true, false, true), mode, false
	)
end

-- Cyrillic language input mode for Mac (toggle by C-s)
vim.o.keymap = "russian-jcukenmac"
vim.o.iminsert = 0
vim.keymap.set({ "n", "i", "c" }, "<C-s>", function()
	local new = vim.o.iminsert == 1 and 0 or 1
	if vim.fn.mode() == "n" then
		vim.o.iminsert = new
	elseif vim.fn.mode() == "i" then
		-- Space + backspace for saving indentation in start of new line.
		feedkeys(" <BS><C-O>:setl iminsert=" .. new .. "<CR>", "n")
	else
		feedkeys("<C-6>", "n")
	end
	-- vim.api.nvim_exec_autocmds("User", { pattern = "InputMethodChanged", modeline = false })
end, { desc = "Toggle iminsert (language map)" })

-- Overall default keymaps
vim.keymap.set(
	"t", "<Esc><Esc>", "<C-\\><C-n>",
	{ desc = "<Escape> to normal mode from terminal" }
)
vim.keymap.set(
	"n", "<C-w>0",
	[[<Cmd>execute ":resize".line("$")<CR>]],
	{ desc = "Resize window height up to lines count" }
)
vim.keymap.set(
	"n", "<C-w>!",
	[[<Cmd>execute ":vertical resize".max(map(getline(1,'$'), 'len(v:val)'))<CR>]],
	{ desc = "Resize window width up to columns count" }
)
vim.keymap.set("n", "<C-w><S-c>", "<Cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set({ "n", "x" }, "<M-y>", [["+]], { desc = "Use + register with one key" })
vim.keymap.set({ "n", "x" }, "<M-p>", [["0]], { desc = "Use 0 register with one key" })
vim.keymap.set("i", "<C-l>", "<C-k>", { desc = "Digraphs remapped from C-k" })

-- Default LSP keymaps
vim.keymap.set({ "i", "s" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "vim.lsp.buf.signature_help()" })

-- <Leader>-based keymaps
vim.keymap.set(
	"n", "<Leader>?", ":map <Leaderr<BS>><CR>",
	{ desc = "Show <Leader> keymaps" }
)
vim.keymap.set(
	"n", "<Leader>l", ":Lazy load ",
	{ desc = ":Lazy load ..." }
)
vim.keymap.set(
	"n", "<Leader>s", "<Cmd>syntax sync fromstart<CR>",
	{ desc = "Sync syntax highlighting" }
)
vim.keymap.set(
	"n", "<Leader>w", function()
		vim.wo.wrap = not vim.wo.wrap
	end,
	{ desc = "Toggle word wrap window option" }
)

-- Diagnostics
vim.diagnostic.config({
	severity_sort = true,
	virtual_text = true
})
vim.keymap.set(
	"n", "gL", function()
		local new_config = not vim.diagnostic.config().virtual_lines
		vim.diagnostic.config({ virtual_lines = new_config })
	end, { desc = "Toggle diagnostic virtual_lines" }
)
vim.keymap.set(
	"n", "gK", vim.diagnostic.open_float,
	{ desc = "Open diagnostic popup window" }
)

-- Highlight copied area
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- SQL keymaps
vim.api.nvim_create_autocmd("FileType", {
	desc = "Bind SQL keymaps",
	pattern = "sql",
	group = augroup,
	callback = function(args)
		vim.keymap.set(
			"n", "<CR>", "vap<CR>",
			{ buffer = args.buf, remap = true, desc = "Query database with paragraph under cursor" }
		)
		vim.keymap.set(
			"x", "<CR>", ":'<,'>DB<CR>",
			{ buffer = args.buf, remap = true, desc = "Query database with selected text" }
		)
		vim.keymap.set(
			"n", "<Leader>=", "<Cmd>%!pg_format<CR>",
			{ buffer = args.buf, remap = true, desc = "Call !pg_format for whole file" }
		)
		vim.keymap.set(
			"x", "<Leader>=", ":!pg_format<CR>",
			{ buffer = args.buf, remap = true, desc = "Call !pg_format for selected text" }
		)
	end
})

-- Prepare and load plugin manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local function config_gitsigns()
	require("gitsigns").setup {
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			vim.keymap.set("n", "]c", function()
				if vim.wo.diff then
					vim.api.nvim_exec2("norm! ]c", {})
				else
					gitsigns.nav_hunk("next")
				end
			end, { buffer = bufnr, desc = "Move to next change hunk" })

			vim.keymap.set("n", "[c", function()
				if vim.wo.diff then
					vim.api.nvim_exec2("norm! [c", {})
				else
					gitsigns.nav_hunk("prev")
				end
			end, { buffer = bufnr, desc = "Move to previous change hunk" })

			vim.keymap.set(
				"n", "<Leader>hs", gitsigns.stage_hunk,
				{ buffer = bufnr, desc = "Git stage hunk of changes" }
			)
			vim.keymap.set("v", "<Leader>hs", function()
				gitsigns.stage_hunk({vim.fn.line("."), vim.fn.line("v")})
			end, { buffer = bufnr, desc = "Git stage hunk of changes" })

			vim.keymap.set(
				"n", "<Leader>hr", gitsigns.reset_hunk,
				{ buffer = bufnr, desc = "Git reset hunk of changes" }
			)
			vim.keymap.set("v", "<Leader>hr", function()
				gitsigns.reset_hunk({vim.fn.line("."), vim.fn.line("v")})
			end, { buffer = bufnr, desc = "Git reset hunk of changes" })

			vim.keymap.set(
				"n", "<Leader>hp", gitsigns.preview_hunk,
				{ buffer = bufnr, desc = "Preview hunk of changes" }
			)

			vim.keymap.set(
				"n", "<Leader>hl", gitsigns.preview_hunk_inline,
				{ buffer = bufnr, desc = "Inline preview hunk of changes" }
			)

			vim.keymap.set(
				{ "o", "x" }, "ih", gitsigns.select_hunk,
				{ buffer = bufnr, desc = "Select hunk (text object)" }
			)
		end
	}
end

local function config_treesitter()
	local max_filesize = 100 * 1024 -- 100 KB
	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = {"bash", "c", "go", "gomod", "lua", "markdown", "python", "vim"},
		callback = function (args)
			local winid = vim.api.nvim_get_current_win()
			local ok, stats = pcall(fs_stat, vim.api.nvim_buf_get_name(args.buf))
			if ok and stats and stats.size > max_filesize then
				return
			end
			vim.treesitter.start(args.buf)
			vim.wo[winid][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			vim.wo[winid][0].foldmethod = 'expr'
		end
	})
end

local function config_fzf()
	vim.api.nvim_create_user_command(
		"Tags", 'call fzf#vim#tags(<q-args>, fzf#vim#with_preview({ ' ..
		'"placeholder": "--tag {2}:{-1}:{3..}", ' ..
		'"window": {"width": nvim_get_option("columns")-6, "height": 0.7, "yoffset": 0} ' ..
		'}), <bang>0)', { nargs = "*", bang = true, desc = "Open fzf with project tags" }
	)
	vim.api.nvim_create_user_command(
		"BTags", 'call fzf#vim#buffer_tags(<q-args>, fzf#vim#with_preview({ ' ..
		'"placeholder": "{2}:{3..}", ' ..
		'"window": {"width": 0.7, "height": 0.7, "yoffset": 0} ' ..
		'}), <bang>0)', { nargs = "*", bang = true, desc = "Open fzf with buffer tags" }
	)
	vim.keymap.set(
		"n", "<Leader>]", "<Cmd>BTags<CR>",
		{ silent = true, desc = "Open fzf with buffer tags" }
	)
	vim.api.nvim_set_var("fzf_preview_window", { "up:40%", "ctrl-/" })
	vim.api.nvim_set_var("fzf_layout", { window = { width = 0.7, height = 0.7, yoffset = 0 } })
end

local function config_telescope()
	local actions = require("telescope.actions")
	require "telescope".setup {
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

	vim.keymap.set(
		"n", "<Leader>b", require("telescope.builtin").buffers,
		{ desc = "Telescope (builtin) buffers" }
	)
	vim.keymap.set(
		"n", "<Leader>e", require("telescope.builtin").oldfiles,
		{ desc = "Telescope (builtin) oldfiles" }
	)
	vim.keymap.set(
		"n", "<Leader>f", require("telescope.builtin").find_files,
		{ desc = "Telescope (builtin) find_files" }
	)
	vim.keymap.set(
		"n", "<Leader>p", require("telescope.builtin").lsp_document_symbols,
		{ desc = "Telescope (builtin) lsp_document_symbols" }
	)
	vim.keymap.set(
		"n", "<Leader>o", require("telescope.builtin").lsp_dynamic_workspace_symbols,
		{ desc = "Telescope (builtin) lsp_dynamic_workspace_symbols" }
	)
end

-- Set default client capabilities before plugins.
-- blink.cmp will automatically update this capabilities on load/setup.
vim.lsp.config("*", {
	capabilities = vim.lsp.protocol.make_client_capabilities()
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.notify(
			"Attached to client " .. args.data.client_id .. " at buffer " .. args.buf,
			vim.log.levels.INFO
		)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, args.buf)
		end
		local win = vim.api.nvim_get_current_win()
		vim.o.signcolumn = "yes:1"
		-- vim.wo[win][0].signcolumn = "yes:1"
		if client:supports_method('textDocument/foldingRange') then
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end

		vim.api.nvim_buf_create_user_command(
			args.buf, "LspDocumentHighlight",
			vim.lsp.buf.document_highlight,
			{ desc = "Highlight symbol under cursor" }
		)
		vim.api.nvim_buf_create_user_command(
			args.buf, "LspClearReferences",
			vim.lsp.buf.clear_references,
			{ desc = "Clear document highlights" }
		)
		vim.api.nvim_buf_create_user_command(
			args.buf, "LspTypeDefinition",
			vim.lsp.buf.type_definition,
			{ desc = "Jump to type definition" }
		)

		vim.keymap.set(
			"n", "gd", vim.lsp.buf.definition,
			{ buffer = args.buf, desc = "Jump to definition" }
		)
		vim.keymap.set(
			"n", "g<C-d>", vim.lsp.buf.declaration,
			{ buffer = args.buf, desc = "Jump to declaration" }
		)
		vim.keymap.set(
			"n", "gD", vim.lsp.buf.type_definition,
			{ buffer = args.buf, desc = "Jump to type definition" }
		)
		vim.keymap.set(
			"n", "<Leader>=", vim.lsp.buf.format,
			{ buffer = args.buf, desc = "Format buffer with LSP" }
		)
	end
})

local lsp_servers = {
	"bashls",
	"clangd",
	"dockerls",
	"gopls",
	"lua_ls",
	"pyright",
	"ts_ls",
	"vimls",
	"yamlls",
}

local function config_lsp()
	vim.lsp.config("pyright", {
		on_init = function(client)
			local pythonPath = client.config.root_dir .. "/.venv/bin/python"
			if fs_stat(pythonPath) then
				client.config.settings.python.pythonPath = pythonPath
				client.notify("workspace/didChangeConfiguration")
			end
			return true
		end
	})
	vim.lsp.config("yamlls", {
		settings = {
			yaml = {
				schemas = {
					["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
					-- ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "openapi.*.yaml"
				},
			},
		}
	})
	vim.lsp.enable(lsp_servers)
end

local function config_dap()
	---@diagnostic disable-next-line: unused-local
	require("dap").listeners.after.event_initialized["dap-keymaps"] = function(session, body)
		-- NOTE: Maybe set keymaps for buffer only.
		vim.keymap.set(
			"n", "<F7>", require("dap").step_out,
			{ desc = "DAP: Step out" }
		)
		vim.keymap.set(
			"n", "<F8>", require("dap").continue,
			{ desc = "DAP: Continue" }
		)
		vim.keymap.set(
			"n", "<F9>", require("dap").step_into,
			{ desc = "DAP: Step into" }
		)
		vim.keymap.set(
			"n", "<F10>", require("dap").step_over,
			{ desc = "DAP: Step over" }
		)
	end

	vim.keymap.set(
		{ "n", "v" }, "<Leader>dh", require("dap.ui.widgets").hover,
		{ desc = "DAP: Hover widget" }
	)
	vim.keymap.set(
		{ "n", "v" }, "<Leader>dp", require("dap.ui.widgets").preview,
		{ desc = "DAP: Preview widget" }
	)
	vim.keymap.set(
		"n", "<Leader>df", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end,
		{ desc = "DAP: Frame widget" }
	)
	vim.keymap.set(
		"n", "<Leader>ds", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end,
		{ desc = "DAP: Scopes widget" }
	)

	-- vim.api.nvim_create_user_command(
	-- 	"DapToggleBreakpoint",
	-- 	function() require("dap").toggle_breakpoint() end,
	-- 	{ desc = "DAP: Toggle breakpoint" }
	-- )
	vim.api.nvim_create_user_command(
		"DapSetConditionalBreakpoint",
		function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
		{ desc = "DAP: Set breakpoint with interactivly set condition" }
	)
	vim.api.nvim_create_user_command(
		"DapSetLogpoint",
		function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
		{ desc = "DAP: Set breakpoint for logging" }
	)
end

local function config_dapui()
	local dap, dapui = require("dap"), require("dapui")
	---@diagnostic disable-next-line: missing-fields
	dapui.setup({})
	---@param session dap.Session
	---@param event dap.InitializedEvent
	---@diagnostic disable-next-line: unused-local
	dap.listeners.after.event_initialized["dapui"] = function(session, event)
		dapui.open()
	end
	---@param session dap.Session
	---@param event dap.TerminatedEvent
	---@diagnostic disable-next-line: unused-local
	dap.listeners.before.event_terminated["dapui"] = function(session, event)
		dapui.close()
	end
	---@param session dap.Session
	---@param event any
	---@diagnostic disable-next-line: unused-local
	dap.listeners.before.event_exited["dapui"] = function(session, event)
		dapui.close()
	end
end

local function config_dap_go()
	require("dap-go").setup({
		dap_configurations = {
			{
				type = "go",
				name = "Debug test (flags & args)",
				request = "launch",
				program = "${file}",
				mode = "test",
				args = require("dap-go").get_arguments,
				buildFlags = require("dap-go").get_build_flags,
			},
		}
	})
	vim.keymap.set(
		"n", "<Leader>dd", require("dap-go").debug_test,
		{ desc = "DAP-Go: Debug test" }
	)
end

---@diagnostic disable-next-line: missing-fields
require("lazy").setup({
	spec = {
		"tpope/vim-fugitive",
		"tpope/vim-surround",
		"tpope/vim-repeat",
		"tpope/vim-vinegar",
		"tpope/vim-unimpaired",
		"justinmk/vim-sneak",
		"junegunn/gv.vim",
		"nmac427/guess-indent.nvim",

		{
			"rebelot/heirline.nvim",
			config = require("statusline")
		},

		{
			"lewis6991/gitsigns.nvim",
			config = config_gitsigns,
		},

		{
			"nvim-treesitter/nvim-treesitter",
			branch = "main",
			lazy = false,
			build = ":TSUpdate",
			config = config_treesitter
		},

		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
			config = config_telescope,
		},

		{
			"junegunn/fzf",
			dependencies = { "junegunn/fzf.vim" },
			config = config_fzf,
		},

		{
			"saghen/blink.cmp",
			version = "1.*",
			dependencies = {
				"rafamadriz/friendly-snippets",
				"tpope/vim-dadbod",
				"kristijanhusak/vim-dadbod-completion",
			},
			opts = {
				keymap = { preset = "default" },
				completion = {
					menu = {
						border = "single",
						draw = {
							columns = { { "label", "kind", "label_description", gap = 1 } },
							padding = { 0, 0 }
						}
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 500,
						window = { border = "single" }
					},
				},
				signature = { window = { border = "single" } },
				sources = {
					per_filetype = {
						sql = { "snippets", "dadbod", "buffer" },
						lua = { "lsp", "path", "snippets", "lazydev" },
					},
					providers = {
						dadbod = { module = "vim_dadbod_completion.blink" },
						lazydev = { module = "lazydev.integrations.blink", score_offset = 100 }
					}
				}
			},
			---@param plugin LazyPlugin
			build = function(plugin)
				vim.notify("Building blink.cmp", vim.log.levels.INFO)
				local obj = vim.system({ "cargo", "build", "--release" }, { cwd = plugin.dir }):wait()
				if obj.code == 0 then
					vim.notify("Building blink.cmp done", vim.log.levels.INFO)
				else
					vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
				end
			end,
		},

		{
			"williamboman/mason.nvim",
			config = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
					}
				},
			}
		},

		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
			opts = {
				ensure_installed = lsp_servers,
				automatic_installation = true,
			},
		},

		{
			"neovim/nvim-lspconfig",
			config = config_lsp,
		},

		{
			"j-hui/fidget.nvim",
			opts = {},
		},

		{
			"tpope/vim-eunuch",
			lazy = true,
		},

		{
			"tpope/vim-characterize",
			keys = "ga"
		},

		{
			"SmiteshP/nvim-navic",
			lazy = true,
			opts = { icons = { enabled = false } }
		},

		{
			"folke/trouble.nvim",
			lazy = true,
			opts = {
				fold_open = "v",
				fold_closed = ">",
				signs = { error = "✖", warning = "⚠︎", hint = "☞", information = "ℹ︎", other = "?" },
			},
		},

		{
			"sindrets/diffview.nvim",
			lazy = true,
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require "diffview".setup({
					use_icons = false,
					icons = {
						folder_closed = "+",
						folder_open = "-",
					},
				})
			end
		},

		{
			"mfussenegger/nvim-dap",
			dependencies = { "rcarriga/nvim-dap-ui" },
			config = config_dap,
		},

		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
			config = config_dapui,
		},

		{
			"leoluz/nvim-dap-go",
			ft = "go",
			dependencies = { "mfussenegger/nvim-dap" },
			config = config_dap_go,
		},

		{
			"folke/lazydev.nvim",
			ft = "lua",
			config = true
		},

		{
			"fatih/vim-go",
			ft = "go",
			config = function()
				vim.g.go_doc_keywordprg_enabled = 0
				vim.g.go_debug_mappings = {
					['(go-debug-breakpoint)'] = { key = '<F6>' },
					['(go-debug-stepout)'] = { key = '<F7>' },
					['(go-debug-continue)'] = { key = '<F8>' },
					['(go-debug-step)'] = { key = '<F9>' },
					['(go-debug-next)'] = { key = '<F10>' },
				}
			end
		},

		{
			"psf/black",
			branch = "main",
			ft = "python"
		},

		{
			"Vimjas/vim-python-pep8-indent",
			ft = "python"
		},

		{
			"lifepillar/pgsql.vim",
			ft = "sql",
			config = function()
				vim.g.sql_type_default = "pgsql"
			end
		},

		{
			"dag/vim-fish",
			ft = { "fish" },
			config = function()
				vim.api.nvim_create_autocmd("FileType", {
					desc = "Fish file settings",
					pattern = "fish",
					group = augroup,
					---@diagnostic disable-next-line: unused-local
					callback = function(args)
						vim.api.nvim_exec2("compiler fish", {})
						vim.wo[vim.api.nvim_get_current_win()][0].foldmethod = "expr"
					end
				})
			end
		},

		{
			"fladson/vim-kitty",
			ft = "kitty"
		},

		{
			"dstein64/vim-startuptime",
			cmd = "StartupTime",
			config = function()
				vim.g.startuptime_tries = 20
			end
		},
	},

	install = { colorscheme = { "cterm256" } },
	-- checker = { enabled = true },

	ui = {
		border = "rounded",
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			import = "📦",
			keys = "🗝",
			lazy = "💤 ",
			loaded = "●",
			not_loaded = "○",
			plugin = "🔌",
			require = "🌙",
			runtime = "💻",
			source = "📄",
			start = "🚀",
			task = "✔",
			list = { "●", "➜", "★", "‒" },
		}
	}
})

-- https://github.com/rebelot/heirline.nvim/blob/master/cookbook.md
local function setup()
	vim.o.laststatus = 3

	local conditions = require("heirline.conditions")

	local space = { provider = " " }

	local input_mode = {
		condition = function()
			return vim.bo.iminsert ~= 0
		end,
		provider = function()
			return "   " .. vim.b.keymap_name .. " "
		end,
		hl = { ctermfg = 15, ctermbg = 16 },
	}

	local vim_mode = {
		init = function(self)
			self.mode = vim.fn.mode(1)
		end,
		static = {
			mode_names = {
				n = "N",
				no = "N?",
				nov = "N?",
				noV = "N?",
				["no\22"] = "N?",
				niI = "Ni",
				niR = "Nr",
				niV = "Nv",
				nt = "Nt",
				v = "V",
				vs = "Vs",
				V = "V_",
				Vs = "Vs",
				["\22"] = "^V",
				["\22s"] = "^V",
				s = "S",
				S = "S_",
				["\19"] = "^S",
				i = "I",
				ic = "Ic",
				ix = "Ix",
				R = "R",
				Rc = "Rc",
				Rx = "Rx",
				Rv = "Rv",
				Rvc = "Rv",
				Rvx = "Rv",
				c = "C",
				cv = "Ex",
				r = "...",
				rm = "M",
				["r?"] = "?",
				["!"] = "!",
				t = "T",
			},
			mode_colors = {
				n = 3,
				i = 2,
				v = 6,
				V = 6,
				["\22"] = 6,
				c = 4,
				s = 5,
				S = 5,
				["\19"] = 5,
				R = 4,
				r = 4,
				["!"] = 3,
				t = 3,
			}
		},
		provider = function(self)
			return " %2(" .. self.mode_names[self.mode] .. "%) "
		end,
		hl = function(self)
			local mode = self.mode:sub(1, 1)
			return { ctermfg = self.mode_colors[mode], ctermbg = 0, bold = true, }
		end,
		update = {
			"ModeChanged",
			pattern = "*:*",
			callback = vim.schedule_wrap(function()
				vim.cmd("redrawstatus")
			end),
		},
	}

	require("heirline").setup({
		---@diagnostic disable-next-line: missing-fields
		statusline = {
			hl = function()
				if conditions.is_active() then
					return "StatusLine"
				else
					return "StatusLineNC"
				end
			end,

			fallthrough = false,

			{
				-- Code path of cursor.
				{
					condition = function()
						return require("nvim-navic").is_available()
					end,
					provider = function()
						return "󰑪  " .. require("nvim-navic").get_location({ highlight = true })
					end,
					update = "CursorMoved"
				},

				-- Alignment.
				{ provider = "%=" },

				-- DAP active debugging session.
				{
					condition = function()
						local session = require("dap").session()
						return session ~= nil
					end,
					provider = function()
						return "   " .. require("dap").status() .. " "
					end,
					hl = { ctermfg = 3, ctermbg = 233 }
				},

				-- Diagnostics.
				{
					condition = conditions.has_diagnostics,
					update = { "DiagnosticChanged", "BufEnter" },
					on_click = {
						name = "heirline_diagnostic",
						---@diagnostic disable-next-line: missing-fields
						callback = function () require("trouble").toggle({ mode = "diagnostics" }) end,
					},
					static = {
						error_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.ERROR],
						warn_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.WARN],
						info_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.INFO],
						hint_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.HINT],
					},
					init = function(self)
						self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
						self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
						self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
						self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
						self.last = 0
						if self.info > 0 then
							self.last = 3
						elseif self.hints > 0 then
							self.last = 2
						elseif self.warnings > 0 then
							self.last = 1
						end
					end,
					{ provider = "[", },
					{
						provider = function(self)
							return self.errors > 0 and (self.error_icon .. self.errors)
						end,
						hl = "DiagnosticError",
					},
					{
						provider = function(self)
							return self.warnings > 0 and (self.warn_icon .. self.warnings)
						end,
						hl = "DiagnosticWarn",
					},
					{
						provider = function(self)
							return self.info > 0 and (self.info_icon .. self.info)
						end,
						hl = "DiagnosticInfo",
					},
					{
						provider = function(self)
							return self.hints > 0 and (self.hint_icon .. self.hints)
						end,
						hl = "DiagnosticHint",
					},
					{ provider = "]", },
				},

				-- Git repo changes.
				{
					condition = conditions.is_git_repo,
					on_click = {
						name = "heirline_git",
						callback = function () vim.cmd("G") end,
					},
					init = function(self)
						self.status_dict = vim.b.gitsigns_status_dict
						if self.status_dict.added == nil then
							return
						end
						self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
								self.status_dict.changed ~= 0
					end,

					{
						provider = function(self) return "   " .. self.status_dict.head end,
						hl = { bold = true }
					},
					{
						condition = function(self) return self.has_changes end,
						provider = "("
					},
					{
						provider = function(self)
							local count = self.status_dict.added or 0
							return count > 0 and ("+" .. count)
						end,
						-- TODO: Colors like Added/Removed/Changed but close to main background.
						hl = { fg = "git_add" },
					},
					{
						provider = function(self)
							local count = self.status_dict.removed or 0
							return count > 0 and ("-" .. count)
						end,
						hl = { fg = "git_del" },
					},
					{
						provider = function(self)
							local count = self.status_dict.changed or 0
							return count > 0 and ("~" .. count)
						end,
						hl = { fg = "git_change" },
					},
					{
						condition = function(self) return self.has_changes end,
						provider = ")",
					},
					space,
				},

				{
					-- %l = current line number
					-- %L = number of lines in the buffer
					-- %c = column number
					-- %P = percentage through file of displayed window
					provider = "%7(%l/%3L%):%2c %P",
				},
				space,
				input_mode,
				vim_mode,
			}
		},

		---@diagnostic disable-next-line: missing-fields
		winbar = {
			{
				{
					condition = function() return vim.bo.modified end,
					{ { provider = "[+]", hl = { ctermfg = 6 } }, space }
				},
				{
					condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
					{ { provider = "[-]", hl = { ctermfg = 3 } }, space }
				},
			},

			-- Calculate git hash prefix and trimmed filename.
			{
				init = function()
					local bid = vim.api.nvim_get_current_buf()
					if vim.b[bid].winbar_filename ~= nil then
						return
					end
					local winbar_filename = vim.api.nvim_buf_get_name(0)

					if winbar_filename:sub(1, 12) == "fugitive:///" then
						local git_x, git_y = winbar_filename:find(".git//", 12)
						local ref_y = winbar_filename:find("/", git_y + 1)
						if ref_y ~= nil then
							local git_ref = winbar_filename:sub(git_y + 1, ref_y - 1)
							if git_ref:len() == 40 then
								git_ref = git_ref:sub(1, 8)
							end
							vim.b[bid].git_ref = git_ref
							winbar_filename = winbar_filename:sub(12, git_x - 1) .. winbar_filename:sub(ref_y + 1)
						end
					end

					winbar_filename = vim.fn.fnamemodify(winbar_filename, ":~:.")
					if winbar_filename == "" then return "[No Name]" end
					if not conditions.width_percent_below(#winbar_filename, 0.25) then
						winbar_filename = vim.fn.pathshorten(winbar_filename)
					end

					vim.b[bid].winbar_filename = winbar_filename
				end,

				-- Git reference of window's buffer.
				{
					condition = function()
						return vim.b.git_ref ~= nil
					end,
					{
						provider = function()
							return "[git(" .. vim.b.git_ref .. ")]"
						end,
						hl = { ctermbg = 236 }, -- Set bg, beacause in WinBar i use a "reverse".
					},
					{ provider = " " },
				},

				-- Computed and cached buffer filename.
				{
					provider = function()
						return vim.b.winbar_filename
					end
				},
			}
		},

		opts = {
			disable_winbar_cb = function(args)
				if vim.api.nvim_buf_get_name(args.buf) ~= "" then
					return false
				end
				if vim.b.netrw_prvdir ~= nil then
					return false
				end
				return true
			end
		}
	})
end

return setup

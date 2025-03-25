local cterm_theme = {
  inactive = { c = 'StatusLineNC' },
  normal = { a = 'StatusLine', b = { bg = 16 }, c = 'StatusLine' },
  insert = { a = { fg = 233, bg = 2, gui = "bold" } },
  replace = { a = { fg = 233, bg = 6, gui = "bold" } },
  visual = { a = { fg = 233, bg = 5, gui = "bold" } },
  command = { a = { fg = 233, bg = 1, gui = "bold"} },
}
cterm_theme.terminal = cterm_theme.command

local minwidth = function() return vim.fn.winwidth(0) > 50 end

require("lualine").setup {
  options = {
    icons_enabled = false,
    theme = cterm_theme,
    component_separators = { left = "〉", right = "〈" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = {
      {
        function()
          if vim.bo.iminsert == 0 then
            return ""
          else
            return "   " .. vim.b.keymap_name .. " "
          end
        end,
        color = { fg = 15, bg = 16 },
        separator = {}, padding = 0,
      },
      "mode",
    },
    lualine_b = {
      {
        "diff",
        cond = function() return vim.fn.winwidth(0) > 40 end,
        diff_color = {
          added = {fg = 2, bg = 16},
          modified = {fg = 4, bg = 16},
          removed = {fg = 1, bg = 16}
        },
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {error = "✖", warn = "⚠︎", info = "ℹ︎", hint = "✎"},
        diagnostics_color = {
            error = 'DiagnosticError',
            warn  = 'DiagnosticWarn',
            info  = 'DiagnosticInfo',
            hint  = 'DiagnosticHint',
        },
        cond = minwidth
      }
    },
    lualine_c = { "filename", "navic" },
    lualine_x = { { "filetype", cond = minwidth } },
    lualine_y = { { "progress", cond = minwidth } },
    lualine_z = { "location" }
  },
}

vim.api.nvim_create_autocmd({"User"}, {
  pattern = "InputMethodChanged",
  callback = function(args)
    require("lualine").refresh()
  end,
})

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

local minwidth = function() return vim.fn.winwidth(0) > 50 end

require('lualine').setup {
  options = {
    theme = cterm_theme,
    component_separators = { left = '〉', right = '〈' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      {
        function()
          if vim.bo.iminsert == 0 then
            return ''
          else
            return '   ' .. vim.b.keymap_name .. ' '
          end
        end,
        color = { fg = 15, bg = 0 },
        separator = {}, padding = 0,
      },
      'mode',
    },
    lualine_b = {
      {
        'diff',
        cond = function() return vim.fn.winwidth(0) > 40 end,
        diff_color = {
          added = {fg = 2},
          modified = {fg = 4},
          removed = {fg = 1}
        },
      },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        cond = minwidth
      }
    },
    lualine_c = { 'filename' },
    lualine_x = { { 'filetype', cond = minwidth } },
    lualine_y = { { 'progress', cond = minwidth } },
    lualine_z = { 'location' }
  },
}

vim.api.nvim_create_autocmd({"User"}, {
  pattern = "InputMethodChanged",
  callback = function(args)
    require('lualine').refresh()
  end,
})

local function on_attach(bufnr)
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  local gs = require('gitsigns')

  -- Наваигация
  map('n', ']c', function()
    if vim.wo.diff then
      vim.cmd.normal({ ']c', bang = true })
    else
      gs.nav_hunk('next')
    end
  end)

  map('n', '[c', function()
    if vim.wo.diff then
      vim.cmd.normal({ '[c', bang = true })
    else
      gs.nav_hunk('prev')
    end
  end)

  -- Действия
  map('n', '<leader>hs', gs.stage_hunk)
  map('n', '<leader>hr', gs.reset_hunk)
  map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
  map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
  map('n', '<Leader>hp', gs.preview_hunk)
  map('n', '<Leader>hu', gs.undo_stage_hunk)
  map('n', '<Leader>hc', gs.toggle_signs)
  map('n', '<Leader>hl', gs.toggle_linehl)
  map('n', '<Leader>hb', function() gs.blame_line { full = true } end)
  map('n', '<Leader>hd', gs.diffthis)
  map('n', '<Leader>hD', function() gs.diffthis('~') end)

  -- Текстовый объект
  map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
end

require('gitsigns').setup {
  attach_to_untracked = false,
  signcolumn = false,
  linehl = true,
  numhl = false,
  on_attach = on_attach,
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

local function map(mode, l, r, opts)
  opts = opts or {}
  opts.buffer = bufnr
  vim.keymap.set(mode, l, r, opts)
end

local function map_navigation(key, callback)
  return function()
    if vim.wo.diff then return key end
    vim.schedule(function() callback() end)
    return '<Ignore>'
  end
end

local function on_attach(bufnr)
  local gs = package.loaded.gitsigns

  -- Наваигация
  for key, callback in pairs({ [']c'] = gs.next_hunk, ['[c'] = gs.prev_hunk }) do
    map('n', key, map_navigation(key, callback), { expr = true })
  end

  -- Действия
  map({'n', 'v'}, '<Leader>hs', ':Gitsigns stage_hunk<CR>')
  map({'n', 'v'}, '<Leader>hr', ':Gitsigns reset_hunk<CR>')
  map('n', '<Leader>hS', gs.stage_buffer)
  map('n', '<Leader>hR', gs.reset_buffer)
  map('n', '<Leader>hp', gs.preview_hunk)
  map('n', '<Leader>hu', gs.undo_stage_hunk)
  map('n', '<Leader>hc', gs.toggle_signs)
  map('n', '<Leader>hl', gs.toggle_linehl)
  map('n', '<Leader>hb', function() gs.blame_line{full=true} end)
  -- map('n', '<Leader>tb', gs.toggle_current_line_blame)
  map('n', '<Leader>hd', gs.diffthis)
  map('n', '<Leader>hD', function() gs.diffthis('~') end)
  -- map('n', '<Leader>td', gs.toggle_deleted)

  -- Текстовый объект
  map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
end

require('gitsigns').setup {
  attach_to_untracked = false,
  signcolumn = false,
  linehl = true,
  numhl = false,
  on_attach = on_attach,
}

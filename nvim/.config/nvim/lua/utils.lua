local cmd = vim.cmd
local M = {}

-- Thanks: https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/lua/config/utils.lua
M.autocmd = function(group, cmds, clear)
  clear = clear == nil and false or clear
  if type(cmds) == 'string' then cmds = {cmds} end
  cmd('augroup ' .. group)
  if clear then cmd [[au!]] end
  for _, c in ipairs(cmds) do cmd('autocmd ' .. c) end
  cmd [[augroup END]]
end

-- Thanks: https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/lua/config/utils.lua
M.map = function(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  if type(modes) == 'string' then modes = {modes} end
  for _, mode in ipairs(modes) do vim.api.nvim_set_keymap(mode, lhs, rhs, opts) end
end

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

return M

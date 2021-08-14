local exec = vim.api.nvim_command
local M = {}

M.complete = function(arg, cmd, cur)
  options = {
  'difftool',
  'diffsplit',
  'diffview',
  'gitgutter',
  'register',
  }
  if arg == '' then
    return options
  end

  filtered = {}
  for _, opt in pairs(options) do
    if string.find(opt, arg) then
      table.insert(filtered, opt)
    end
  end
  return filtered
end

M.mergebase = function(option)
  rev = vim.fn.systemlist('git merge-base develop HEAD')[1]

  if option == 'difftool' then
    exec('Git difftool ' .. rev)

  elseif option == 'diffsplit' then
    exec('Gdiffsplit ' .. rev)

  elseif option == 'diffview' then
    exec('DiffviewOpen ' .. rev)

  elseif option == 'gitgutter' then
    vim.g.gitgutter_diff_base = rev
    exec 'GitGutter'

  elseif option == 'register' then
    exec(' let @m = "' .. rev .. '"')

  end
end

return M

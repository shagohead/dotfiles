return function()
  local actions = require "telescope.actions"
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

  vim.cmd([[
  nnoremap <Leader>b <Cmd>Telescope buffers theme=dropdown<CR>
  nnoremap <Leader>e <Cmd>Telescope oldfiles theme=dropdown<CR>
  nnoremap <Leader>f <Cmd>Telescope find_files theme=dropdown<CR>
  nnoremap <Leader>o <Cmd>lua require "telescope.builtin".lsp_dynamic_workspace_symbols(require("telescope.themes").get_dropdown({layout_config={width=vim.api.nvim_get_option("columns")-6}}))<CR>
  nnoremap <Leader>p <Cmd>lua require "telescope.builtin".lsp_document_symbols(require("telescope.themes").get_dropdown())<CR>
  ]])
end

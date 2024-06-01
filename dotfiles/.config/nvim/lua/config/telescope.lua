return function()
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

  vim.keymap.set("n", "<Leader>b", require("telescope.builtin").buffers)
  vim.keymap.set("n", "<Leader>e", require("telescope.builtin").oldfiles)
  vim.keymap.set("n", "<Leader>f", require("telescope.builtin").find_files)
  vim.keymap.set("n", "<Leader>p", require("telescope.builtin").lsp_document_symbols)
  vim.keymap.set("n", "<Leader>o", require("telescope.builtin").lsp_dynamic_workspace_symbols)
end

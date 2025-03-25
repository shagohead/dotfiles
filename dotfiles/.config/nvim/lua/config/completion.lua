return function()
  local cmp = require 'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('snippy').expand_snippet(args.body)
      end,
    },
    mapping = {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      ['<C-y>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
      ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<Tab>'] = function(fallback)
        if cmp.visible() then cmp.select_next_item() else fallback() end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then cmp.select_prev_item() else fallback() end
      end,
    },
    sources = {
      { name = 'lazydev', group_index = 0 },
      { name = 'nvim_lsp', max_item_count = 20 },
      { name = 'buffer', keyword_length = 3, max_item_count = 10 },
      { name = 'snippy', max_item_count = 10 },
    },
  })

  vim.cmd([[
  augroup completion
  autocmd!
  au FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion', keyword_length = 2, max_item_count = 30 }, { name = 'buffer', keyword_length = 3, max_item_count = 10 }} })
  augroup END
  ]])
end

return function()
  local lspkind = require 'lspkind'
  local cmp = require 'cmp'

  lspkind.init({
    symbol_map = {
      Text = "✍",
      Method = "⇒",
      Function = "ƒ",
      Constructor = "",
      Field = "ﰠ",
      Variable = "𝓍",
      Class = "ℂ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "𝕊",
      Event = "",
      Operator = "",
      TypeParameter = ""
    },
  })

  cmp.setup({
    snippet = {
      expand = function(args)
        require 'snippy'.expand_snippet(args.body)
      end,
    },
    mapping = {
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
      { name = 'nvim_lsp', max_item_count = 20 },
      { name = 'buffer', keyword_length = 3, max_item_count = 10 },
      { name = 'snippy', max_item_count = 10 },
    },
    formatting = {
      format = lspkind.cmp_format {
        mode = 'symbol_text'
      }
    },
  })

  vim.cmd([[
  augroup completion
  autocmd!
  au FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion', keyword_length = 2, max_item_count = 30 }, { name = 'buffer', keyword_length = 3, max_item_count = 10 }} })
  augroup END
  ]])
end

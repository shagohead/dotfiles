local lspconfig = require 'lspconfig'
local lspkind = require 'lspkind'
local cmp = require 'cmp'

local capabilities = vim.lsp.protocol.make_client_capabilities()

local servers = {
  'bashls',
  'dockerls',
  'gopls',
  'tsserver',
  'vimls'
}

local on_attach = function(client, bufnr)
  print('Attached to '..client.name..' for buf #'..bufnr)
  vim.cmd([[
  setlocal signcolumn=yes
  setlocal omnifunc=v:lua.vim.lsp.omnifunc
  nnoremap <buffer> <M-k> <Cmd>lua vim.lsp.buf.signature_help()<CR>
  inoremap <buffer> <M-k> <Cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <buffer> K <Cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <buffer> gd <Cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <buffer> gi <Cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <buffer> gr <Cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <buffer> [w <Cmd>lua vim.diagnostic.goto_prev()<CR>
  nnoremap <buffer> ]w <Cmd>lua vim.diagnostic.goto_next()<CR>
  nnoremap <buffer> <Leader>l :Lsp
  nnoremap <buffer> <Leader>w <Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
  nnoremap <buffer> <Leader>a <Cmd>lua vim.lsp.buf.code_action()<CR>
  xnoremap <buffer> <Leader>a <Cmd>lua vim.lsp.buf.range_code_action()<CR>
  nnoremap <buffer> <Leader>= <Cmd>lua vim.lsp.buf.formatting()<CR>
  xnoremap <buffer> <Leader>= <Cmd>lua vim.lsp.buf.formatting()<CR>
  command! -nargs=0 -buffer LspRename lua vim.lsp.buf.rename()
  command! -nargs=0 -buffer LspTypeDef lua vim.lsp.buf.type_definition()
  command! -nargs=0 -buffer DiagnosticList lua vim.lsp.diagnostic.set_loclist()
  command! -nargs=0 -buffer WorkspaceAdd lua vim.lsp.buf.add_workspace_folder()
  command! -nargs=0 -buffer WorkspaceRemove lua vim.lsp.buf.remove_workspace_folder()
  command! -nargs=0 -buffer WorkspaceList lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  packadd lsp_signature.nvim
  packadd trouble.nvim
  nnoremap <buffer> <Leader>q :Trouble
  augroup lightbulb
  autocmd!
  au CursorHold,CursorHoldI <buffer> lua require'nvim-lightbulb'.update_lightbulb()
  augroup END
  ]])
  require 'trouble'.setup { mode = 'document_diagnostics' }
  require 'lsp_signature'.on_attach({ bind = true, hint_enable = false, handler_opts = { border = 'none' } }, bufnr)
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { on_attach = on_attach, capabilities = capabilities }
end

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = function(client)
    local pythonPath = client.config.root_dir .. '/.venv/bin/python'
    if vim.loop.fs_stat(pythonPath) then
      client.config.settings.python.pythonPath = pythonPath
      client.notify('workspace/didChangeConfiguration')
    end
    return true
  end
}

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

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
      mode = 'symbol', with_text = true,
      menu = { nvim_lsp = 'lsp', buffer = 'buf' }
    }
  },
})

vim.cmd([[
augroup completion
autocmd!
au FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion', keyword_length = 2, max_item_count = 30 }, { name = 'buffer', keyword_length = 3, max_item_count = 10 }} })
augroup END
]])

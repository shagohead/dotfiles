return function()
  local on_attach = function(client, bufnr)
  -- TODO: set signcolumn=yes
    print('Attached to '..client.name..' for buf #'..bufnr)
    vim.cmd([[
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
    nnoremap <buffer> <Leader>q <Cmd>TroubleToggle<CR>
    nnoremap <buffer> <Leader>a <Cmd>lua vim.lsp.buf.code_action()<CR>
    xnoremap <buffer> <Leader>a <Cmd>lua vim.lsp.buf.range_code_action()<CR>
    nnoremap <buffer> <Leader>= <Cmd>lua vim.lsp.buf.formatting()<CR>
    xnoremap <buffer> <Leader>= <Cmd>lua vim.lsp.buf.formatting()<CR>
    command! -nargs=0 -buffer LspRename lua vim.lsp.buf.rename()
    command! -nargs=0 -buffer LspTypeDef lua vim.lsp.buf.type_definition()
    command! -nargs=0 -buffer DiagnosticList lua vim.lsp.diagnostic.set_loclist()
    command! -nargs=0 -buffer DiagnosticList lua vim.lsp.diagnostic.set_loclist()
    command! -nargs=0 -buffer WorkspaceAdd lua vim.lsp.buf.add_workspace_folder()
    command! -nargs=0 -buffer WorkspaceRemove lua vim.lsp.buf.remove_workspace_folder()
    command! -nargs=0 -buffer WorkspaceList lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    au CursorHold,CursorHoldI <buffer> lua require'nvim-lightbulb'.update_lightbulb()
    packadd lsp_signature.nvim
    packadd trouble.nvim
    ]])
    require 'trouble'.setup {
      icons = false,
      mode = 'document_diagnostics'
    }
    require 'lsp_signature'.on_attach({
      bind = true,
      hint_enable = true,
      handler_opts = {
        border = 'rounded'
      }
    }, bufnr)
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local lspconfig = require 'lspconfig'

  for _, lsp in ipairs({
    'bashls',
    'dockerls',
    'gopls',
    'rust_analyzer',
    'tsserver',
    'vimls'
  }) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities
    }
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

  function filter(arr, func)
    -- Filter in place
    -- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
    local new_index = 1
    local size_orig = #arr
    for old_index, v in ipairs(arr) do
      if func(v, old_index) then
        arr[new_index] = v
        new_index = new_index + 1
      end
    end
    for i = new_index, size_orig do arr[i] = nil end
  end


  function filter_diagnostics(diagnostic)
    if diagnostic.source ~= "Pyright" then
      return true
    end

    if diagnostic.tags then
      for _, v in ipairs(diagnostic.tags) do
        -- Исключаю сообщения с тэгом Unnecessary и текстом про неиспользуемые
        -- переменные *args, **kwargs, и, тем более, self.
        -- Про тэг: https://github.com/microsoft/pyright/issues/982#issuecomment-684045241
        if v == 1 and (
            diagnostic.message == '"self" is not accessed' or
            diagnostic.message == '"args" is not accessed' or
            diagnostic.message == '"kwargs" is not accessed'
          ) then
          return false
        end
      end
    end
    return true
  end

  function custom_on_publish_diagnostics(a, params, client_id, c, config)
    filter(params.diagnostics, filter_diagnostics)
    vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
  end

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    custom_on_publish_diagnostics, { virtual_text = false }
  )

  local border = 'rounded'

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, { border = border }
  )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, { border = border }
  )

  vim.diagnostic.config{
    float={border=border}
  }

  require('lspconfig.ui.windows').default_options = {
    border = border
  }
end

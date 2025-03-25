-- NVIM LSP configuration
local augroup = vim.api.nvim_create_augroup("init:lsp", { clear = true })

local on_attach = function(client, bufnr)
  print("Attached to " .. client.name .. " for buf #" .. bufnr)

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc()")
  vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
  vim.api.nvim_win_set_option(0, "signcolumn", "yes:1")

  vim.api.nvim_buf_create_user_command(bufnr, "LspRename", function() vim.lsp.buf.rename() end, {})
  vim.api.nvim_buf_create_user_command(bufnr, "LspTypeDef", function() vim.lsp.buf.type_definition() end, {})
  vim.api.nvim_buf_create_user_command(bufnr, "DiagnosticList", function() vim.diagnostic.setloclist() end, {})
  vim.api.nvim_buf_create_user_command(bufnr, "WorkspaceAdd", function() vim.lsp.buf.add_workspace_folder() end, {})
  vim.api.nvim_buf_create_user_command(bufnr, "WorkspaceRemove", function() vim.lsp.buf.remove_workspace_folder() end, {})
  vim.api.nvim_buf_create_user_command(bufnr, "WorkspaceList",
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, {})
  vim.api.nvim_buf_create_user_command(bufnr, "WhereAmI",
    function() print(vim.inspect(require("nvim-navic").get_location())) end, {})

  vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, { buffer = true, desc = "Open symbols outline" })
  vim.keymap.set({ "n", "i" }, "<M-k>", vim.lsp.buf.signature_help,
    { buffer = true, desc = "Open signature help (normal mode)" })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true, desc = "Hover object" })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true, desc = "Goto definition" })
  vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, { buffer = true, desc = "Goto type definition" })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = true, desc = "Goto implementation" })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = true, desc = "Goto references" })
  vim.keymap.set("n", "<Leader>=", vim.lsp.buf.format, { buffer = true, desc = "Format buffer with LSP" })
  vim.keymap.set({ "n", "x" }, "<Leader>a", vim.lsp.buf.code_action, { buffer = true, desc = "Run LSP code action" })
  vim.keymap.set("n", "<Leader>q", require("trouble").toggle, { buffer = true, desc = "Toggle Trouble window" })

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    desc = "Update LSP lightbulb on cursor hold",
    group = augroup,
    callback = function()
      require("nvim-lightbulb").update_lightbulb()
    end,
  })

  require("lsp_signature").on_attach({
    bind = true,
    hint_enable = true,
    handler_opts = {
      border = "rounded"
    }
  }, bufnr)

  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

local setup = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend(
    "force", capabilities, require("cmp_nvim_lsp").default_capabilities()
  )

  local servers = {
    clangd = {},
    bashls = {},
    dockerls = {},
    gopls = {},
    ts_ls = {},
    vimls = {},

    lua_ls = {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    },

    pyright = {
      on_init = function(client)
        local pythonPath = client.config.root_dir .. "/.venv/bin/python"
        if vim.loop.fs_stat(pythonPath) then
          client.config.settings.python.pythonPath = pythonPath
          client.notify("workspace/didChangeConfiguration")
        end
        return true
      end
    },

    yamlls = {
      settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            -- ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "openapi.*.yaml"
          },
        },
      }
    },
  }

  require("mason-lspconfig").setup({
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.on_attach = on_attach
        server.capabilities = vim.tbl_deep_extend(
          "force", {}, capabilities, server.capabilities or {}
        )
        require("lspconfig")[server_name].setup(server)
      end,
    },

    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = false,
  })

  local function filter(arr, func)
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


  local function filter_diagnostics(diagnostic)
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

  local function custom_on_publish_diagnostics(_, result, ctx, config)
    filter(result.diagnostics, filter_diagnostics)
    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    custom_on_publish_diagnostics, { virtual_text = false }
  )

  local border = "rounded"

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, { border = border }
  )

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, { border = border }
  )

  vim.diagnostic.config {
    float = { border = border }
  }

  require("lspconfig.ui.windows").default_options = {
    border = border
  }
end

return {
  on_attach = on_attach,
  setup = setup,
}

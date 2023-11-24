local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "tpope/vim-fugitive",
  "tpope/vim-unimpaired",
  "tpope/vim-commentary",
  "tpope/vim-speeddating",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "tpope/vim-dotenv",
  "tpope/vim-vinegar",
  "justinmk/vim-sneak",
  "fladson/vim-kitty",
  "tommcdo/vim-exchange",
  "junegunn/gv.vim",

  {
    "junegunn/fzf",
    dependencies = { "junegunn/fzf.vim" },
    config = function()
      vim.api.nvim_create_user_command(
        "Tags", 'call fzf#vim#tags(<q-args>, fzf#vim#with_preview({ ' ..
        '"placeholder": "--tag {2}:{-1}:{3..}", ' ..
        '"window": {"width": nvim_get_option("columns")-6, "height": 0.7, "yoffset": 0} ' ..
        '}), <bang>0)', { nargs = "*", bang = true }
      )
      vim.api.nvim_create_user_command(
        "BTags", 'call fzf#vim#buffer_tags(<q-args>, fzf#vim#with_preview({ ' ..
        '"placeholder": "{2}:{3..}", ' ..
        '"window": {"width": 0.7, "height": 0.7, "yoffset": 0} ' ..
        '}), <bang>0)', { nargs = "*", bang = true }
      )
      vim.keymap.set("n", "<Leader>t", "<Cmd>Tags<CR>", { silent = true })
      vim.keymap.set("n", "<Leader>]", "<Cmd>BTags<CR>", { silent = true })
      vim.api.nvim_set_var("fzf_preview_window", { "up:40%", "ctrl-/" })
      vim.api.nvim_set_var("fzf_layout", { window = { width = 0.7, height = 0.7, yoffset = 0 } })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = require "config.lsp",
    dependencies = {
      { "folke/neodev.nvim",        opts = {} },
      { "ray-x/lsp_signature.nvim", lazy = true },
      {
        "folke/trouble.nvim",
        lazy = true,
        opts = {
          -- icons = false,
          fold_open = "v",
          fold_closed = ">",
          -- indent_lines = false,
          signs = {
            error = "✖",
            warning = "⚠︎",
            hint = "☞",
            information = "ℹ︎",
            other = "?",
          },
          -- use_diagnostic_signs = false
        }
      },
      {
        "kosayoda/nvim-lightbulb",
        lazy = true,
        opts = {
          sign = {
            enabled = true,
            priority = 8
          }
        }
      },
    },
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach"
  },

  {
    "nvim-telescope/telescope.nvim",
    config = require "config.telescope",
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "hrsh7th/nvim-cmp",
    config = require "config.completion",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "onsails/lspkind-nvim" },
      { "dcampos/nvim-snippy" },
      { "dcampos/cmp-snippy" },
    },
  },

  {
    -- TODO: Добавить для vim-dadbod-completion поддержку $DATABASE_URL
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    config = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "sql,mysql,plsql",
        callback = function()
          vim.api.nvim_buf_set_option(0, "omnifunc", "vim_dadbod_completion#omni")
          -- TODO: Устанавливать настройки для cmp, если он загружен
          -- require "cmp".setup.buffer({
          --   sources = {
          --     { name = "vim-dadbod-completion", keyword_length = 2, max_item_count = 30 },
          --     { name = "buffer", keyword_length = 3, max_item_count = 10 }
          --   }
          -- })
        end,
      })
    end
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function() require "config.gitsigns" end
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "gitsigns.nvim" },
    config = function() require "config.statusline" end
  },

  {
    "winston0410/range-highlight.nvim",
    dependencies = { "winston0410/cmd-parser.nvim" },
  },

  {
    "preservim/vim-markdown",
    dependencies = { "godlygeek/tabular" }
  },

  {
    "sunaku/vim-dasht",
    config = require "config.dasht"
  },

  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonLog",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonUpdate",
    },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require "nvim-treesitter".setup()
      require "nvim-treesitter.configs".setup {
        refactor = {
          highlight_definitions = {
            enable = true,
            clear_on_cursor_move = false,
          },
        },
      }
      require "treesitter-context".setup {
        enable = true,
        max_lines = 3,
      }
    end
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      {
        "leoluz/nvim-dap-go",
        ft = "go",
        config = function()
          require("dap-go").setup()
          vim.keymap.set("n", "<Leader>dd", require("dap-go").debug_test, { desc = "DAP-Go: Debug test" })
        end
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      dap.listeners.after.event_initialized["dapui"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui"] = function()
        dapui.close()
      end

      vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "🔕", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })

      vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "DAP: Continue" })
      vim.keymap.set("n", "<F10>", require("dap").step_over, { desc = "DAP: Step over" })
      vim.keymap.set("n", "<F11>", require("dap").step_into, { desc = "DAP: Step into" })
      vim.keymap.set("n", "<F12>", require("dap").step_out, { desc = "DAP: Step out" })
      vim.keymap.set("n", "<Leader>B", require("dap").toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
      vim.keymap.set("n", "<Leader>du", require("dapui").toggle, { desc = "DAP-UI: Toggle" })
      vim.keymap.set("n", "<Leader>dr", require("dap").repl.open, { desc = "DAP: Open REPL" })
      vim.keymap.set("n", "<Leader>dl", require("dap").run_last, { desc = "DAP: Run last" })
      vim.keymap.set({ "n", "v" }, "<Leader>dh", function() require("dap.ui.widgets").hover() end,
        { desc = "DAP: Hover widget" })
      vim.keymap.set({ "n", "v" }, "<Leader>dp", function() require("dap.ui.widgets").preview() end,
        { desc = "DAP: Preview widget" })
      vim.keymap.set("n", "<Leader>df", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
      end, { desc = "DAP: Frame widget" })
      vim.keymap.set("n", "<Leader>ds", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end, { desc = "DAP: Scopes widget" })

      vim.api.nvim_create_user_command("DapSetConditionalBreakpoint", function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, {})
      vim.api.nvim_create_user_command("DapSetLogpoint", function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, {})
    end
  },

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 20
    end
  },


  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles"
    },
    config = function()
      require "diffview".setup({
        use_icons = false,
        icons = {
          folder_closed = "+",
          folder_open = "-",
        },
      })
    end
  },

  {
    "tpope/vim-characterize",
    keys = "ga"
  },

  {
    "tpope/vim-eunuch",
    cmd = { "Delete", "Remove", "Move", "Rename", "Mkdir" }
  },

  {
    "psf/black",
    branch = "main",
    ft = "python"
  },

  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python"
  },

  {
    "lifepillar/pgsql.vim",
    ft = "sql",
    config = function()
      vim.g.sql_type_default = "nvim_lsp"
    end
  },

  {
    "dag/vim-fish",
    ft = { "fish" },
    config = function()
      vim.cmd([[
      au FileType fish compiler fish
      au FileType fish setlocal foldmethod=expr
      ]])
    end
  }
}, {
  ui = {
    border = "rounded",
    icons = {
      cmd = ">",
      config = "⚙",
      event = "☇",
      ft = "✉",
      init = "⚙ ",
      import = "← ",
      keys = "⌨",
      lazy = "💤 ",
      loaded = "●",
      not_loaded = "○",
      plugin = "📦",
      runtime = " ",
      source = "<> ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    }
  }
})

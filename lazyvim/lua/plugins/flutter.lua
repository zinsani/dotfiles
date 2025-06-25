return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
  },
  config = true,
  setup = {
    -- debugger
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
      },
      event = "VeryLazy",
      config = function()
        require("dapui").setup({
          icons = { expanded = "▾", collapsed = "▸" },
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.25 },
                "breakpoints",
                "stacks",
                "watches",
              },
              size = 10, -- columns
              position = "bottom",
            },
          },
        })
      end,
    },

    -- flutter
    {
      "akinsho/flutter-tools.nvim",
      event = "VeryLazy",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim",
      },
      config = function()
        require("flutter-tools").setup({
          flutter_path = nil,
          flutter_lookup_cmd = "asdf where flutter",
          fvm = false,
          widget_guides = { enabled = true },
          lsp = {
            settings = {
              showtodos = true,
              completefunctioncalls = true,
              analysisexcludedfolders = {
                vim.fn.expand("$Home/.pub-cache"),
              },
              renamefileswithclasses = "prompt",
              updateimportsonrename = true,
              enablesnippets = false,
            },
          },
          debugger = {
            enabled = true,
            run_via_dap = true,
            exception_breakpoints = {},
            register_configurations = function(paths)
              local dap = require("dap")
              -- See also: https://github.com/akinsho/flutter-tools.nvim/pull/292
              dap.adapters.dart = {
                type = "executable",
                command = paths.flutter_bin,
                args = { "debug-adapter" },
              }
              dap.configurations.dart = {}
              require("dap.ext.vscode").load_launchjs()
            end,
          },
        })
      end,
    },
  },
}

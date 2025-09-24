return {
  {
    "mfussenegger/nvim-dap",
    opts = false,
    config = function()
      require("dap.ext.vscode").load_launchjs()
    end,
  },
  { "theHamsta/nvim-dap-virtual-text" },
  { "mfussenegger/nvim-dap-python" },
  { "nvim-telescope/telescope-dap.nvim" },
  { "leoluz/nvim-dap-go" },
  { "jbyuki/one-small-step-for-vimkind" },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
      -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
      -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
      -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
      -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    },
    config = function(_, opts)
      require("dap-vscode-js").setup(opts)
      local dap = require("dap")
      for _, language in ipairs({ "typescript", "javascript", "vue" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Node",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach - node",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch - Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          {
            type = "pwa-msedge",
            name = "Attach - MSEdge",
            request = "attach",
            cwd = "${workspaceFolder}",
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-msedge",
            name = "Launch - MSEdge",
            request = "launch",
            url = "http://localhost:8080",
          },
        }
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end

      vim.keymap.set("n", "<leader>dd", require("dapui").toggle)
    end,

    dependencies = {
      "mfussenegger/nvim-dap",
    },

    keys = function()
      local ok, dap = pcall(require, "dap")
      local ok2, widgets = pcall(require, "dap.ui.widgets")
      if not ok or not ok2 then
      else
        return {
          {
            "<F5>",
            function()
              dap.continue()
            end,
            mode = "n",
          },
          {
            "<F10>",
            function()
              dap.step_over()
            end,
            mode = "n",
          },
          {
            "<F11>",
            function()
              dap.step_into()
            end,
            mode = "n",
          },
          {
            "<F12>",
            function()
              dap.step_out()
            end,
            mode = "n",
          },
          {
            "<Leader>cb",
            function()
              dap.toggle_breakpoint()
            end,
            mode = "n",
            desc = "DAP toggle breakpoint",
          },
          {
            "<Leader>cB",
            function()
              dap.set_breakpoint()
            end,
            mode = "n",
            desc = "DAP set breakpoint",
          },
          {
            "<Leader>dlp",
            function()
              dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end,
            mode = "n",
            desc = "DAP set breakpoint with Log point message",
          },
          {
            "<Leader>dr",
            function()
              dap.repl.open()
            end,
            mode = "n",
            desc = "DAP open repl",
          },
          {
            "<Leader>dl",
            function()
              dap.run_last()
            end,
            mode = "n",
            desc = "DAP run last",
          },
          {
            "<Leader>dh",
            function()
              widgets.hover()
            end,
            mode = { "n", "v" },
            desc = "DAP UI hover",
          },
          {
            "<Leader>dp",
            function()
              widgets.preview()
            end,
            mode = { "n", "v" },
            desc = "DAP UI preview",
          },
          {
            "<Leader>df",
            function()
              widgets.centered_float(widgets.frames)
            end,
            mode = "n",
            desc = "DAP UI centered float with frames",
          },
          {
            "<Leader>ds",
            function()
              widgets.centered_float(widgets.scopes)
            end,
            mode = "n",
            desc = "DAP UI centered float with scopes",
          },
        }
      end
    end,
  },
}

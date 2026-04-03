return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = false,
        keymap = {
          accept = "<Tab>",
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<C-e>",
        },
      },
    },
    keys = {
      {
        "<leader>ct",
        function()
          local copilot = require("copilot.suggestion")
          -- Track state with a global variable since config access is tricky
          if vim.g.copilot_auto_trigger == nil then
            vim.g.copilot_auto_trigger = false -- matches initial config
          end
          copilot.toggle_auto_trigger()
          vim.g.copilot_auto_trigger = not vim.g.copilot_auto_trigger
          local status = vim.g.copilot_auto_trigger and "enabled" or "disabled"
          vim.notify("Copilot auto_trigger: " .. status)
        end,
        desc = "Toggle Copilot auto-trigger",
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      tools = "copilot",
    },
  },
}

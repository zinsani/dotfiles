return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gs = require("gitsigns")
      gs.setup()
    end,
    keys = {
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "preview hunk " },
      { "<leader>gt", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle current line blame" },
    },
  },
  {
    "FabijanZulj/blame.nvim",
    keys = { { "<leader>gb", "<cmd>ToggleBlame virtual<cr>", desc = "ToggleBlame virtual mode" } },
  },
}

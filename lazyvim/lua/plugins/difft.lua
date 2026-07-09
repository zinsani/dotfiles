return {
  "clabby/difftastic.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = { "Difft", "DifftClose" },
  keys = {
    { "<leader>gd", "<cmd>Difft<cr>", desc = "Difftastic Diff" },
    { "<leader>gD", "<cmd>DifftClose<cr>", desc = "Difftastic Close" },
  },
  config = function()
    require("difftastic-nvim").setup({
      vcs = "jj",
    })
  end,
}

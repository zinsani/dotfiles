return {
  "mbbill/undotree",
  keys = { { "<leader>cu", vim.cmd.UndotreeToggle, desc = "Toggle [U]ndotree" } },
  config = function()
    vim.g.undotree_WindowLayout = 3
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
  opts = { position = "right" },
}

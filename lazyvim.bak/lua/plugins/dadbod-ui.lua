return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_env_variable_url = "DB_HOST"
    vim.g.db_ui_env_variable_name = "DB_DATABASE"
  end,
  keys = {
    -- add a keymap to browse plugin files
    -- stylua: ignore
    {
      "<leader>du",
      function() vim.cmd([[DBUIToggle]]) end,
      desc = "DBUIToggle",
    },
  },
}

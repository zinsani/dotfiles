return {
  {
    "diepm/vim-rest-console",
    enabled = true,
    cmd = { "VrcQuery" },
    ft = { "http", "rest" },
    keys = {
      { "<leader>hh", "<cmd>call VrcQuery()<cr>", desc = "Execute VrcQuery" },
    },
    lazy = false,
    config = function()
      vim.g.vrc_set_default_mapping = 0

      vim.g.vrc_auto_format_response_enabled = 1
      vim.g.vrc_response_default_content_type = "application/json"

      vim.cmd("let g:vrc_auto_format_response_patterns = { 'json' : 'jq' }")
      vim.cmd("let g:vrc_curl_opts = { '-s': '', '-i' : '', }")
    end,
  },
  {
    "rest-nvim/rest.nvim",
    enabled = false,
    dependencies = { { "nvim-lua/plenary.nvim" } },
    keys = {
      { "<leader>hh", "<Plug>RestNvim", desc = "Run Rest Request under cursor" },
      { "<leader>hp", "<Plug>RestNvimPreview", desc = "Preview the request cURL command" },
    },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- stay in current windows (.http file) or change to results window (default)
        stay_in_current_window_after_split = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          -- show the generated curl command in case you want to launch
          -- the same request via the terminal (can be verbose)
          show_curl_command = false,
          show_http_info = true,
          show_headers = true,
          -- table of curl `--write-out` variables or false if disabled
          -- for more granular control see Statistics Spec
          show_statistics = false,
          -- executables or functions for formatting response body [optional]
          -- set them to false if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
        search_back = true,
      })
    end,
  },
}

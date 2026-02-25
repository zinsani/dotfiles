-- return {
--   "iamcco/markdown-preview.nvim",
--   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--   ft = { "markdown" },
--   build = function()
--     vim.fn["mkdp#util#install"]()
--   end,
--   config = function()
--     vim.cmd([[do FileType]])
--     vim.cmd([[
--          function OpenMarkdownPreview (url)
--             let cmd = "google-chrome-stable --new-window " . shellescape(a:url) . " &"
--             silent call system(cmd)
--          endfunction
--       ]])
--     vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
--   end,
-- }

-- install without yarn or npm
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
}

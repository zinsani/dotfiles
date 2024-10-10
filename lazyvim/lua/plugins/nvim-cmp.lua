return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "mlaursen/vim-react-snippets",
  },
  opts = function(_, opts)
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    require("vim-react-snippets").lazy_load()

    table.insert(opts.sources, 1, {
      name = "codeium",
      group_index = 1,
      priority = 100,
    })

    opts.snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    }

    table.insert(opts.sources, { name = "luasnip" })
  end,
}

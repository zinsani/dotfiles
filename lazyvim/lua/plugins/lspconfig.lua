return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        pyright = {},
        tsserver = {},
        volar = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        },
        cssls = {},
        html = {},
        eslint = {},
        -- ocamlls = {},
        -- ocamllsp = {},
      },
      setup = {
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            elseif client.name == "volar" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    ---@class PluginLspOpts
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },
      ---@type lspconfig.options
      servers = {
        pyright = {},
        tsserver = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
          hint = {
            enable = false,
          },
          inlay_hints = {
            enabled = false,
          },
        },
        volar = {
          enabled = false,
          filetypes = { "typescript", "javascript", "vue" },
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

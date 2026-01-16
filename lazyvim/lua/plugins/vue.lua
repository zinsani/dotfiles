return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vuels = { enabled = false },
        vtsls = { enabled = false },
        ts_ls = { enabled = false },
        volar = { enabled = false }, -- Avoid duplication

        -- Configure 'vue_ls' (Volar) for Vue 2 Takeover Mode
        vue_ls = {
          enabled = true,
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
          init_options = {
            vue = {
              hybridMode = false,
            },
            typescript = {
              tsdk = "/Users/jsp/workspace/soomgo/soomgo-frontend/node_modules/typescript/lib",
            },
          },
          -- CRITICAL FIX: Override the default on_init which expects hybrid mode
          -- This prevents nvim-lspconfig from complaining about missing ts_ls/vtsls
          on_init = function(client)
            -- We do nothing here, effectively disabling the default hybrid mode check
            return true
          end,
        },
      },
      setup = {
        -- The Kill Switch: Prevent vtsls and ts_ls from starting
        vtsls = function()
          return true
        end,
        ts_ls = function()
          return true
        end,
      },
    },
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vuels = { enabled = false },
        ts_ls = { enabled = false },
        vue_ls = { enabled = false },

        -- Configure VTSLS (Preferred Server)
        vtsls = {
          enabled = true,
          cmd = {
             "node",
             "--max-old-space-size=8192",
             "/Users/jsp/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/bin/vtsls.js",
             "--stdio",
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,
              tsserver = {
                globalPlugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = "/Users/jsp/.nvm/versions/node/v22.11.0/lib/node_modules/@vue/typescript-plugin",
                    languages = { "vue" },
                    configNamespace = "typescript",
                    enableForWorkspaceTypeScriptVersions = true,
                  },
                },
              },
            },
          },
        },

        -- Configure Volar (Hybrid Mode)
        volar = {
          enabled = true,
          cmd = { 
             "node", 
             "--max-old-space-size=8192", 
             "/Users/jsp/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server/bin/vue-language-server.js", 
             "--stdio" 
          },
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = true,
            },
            typescript = {
              tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
            },
          },
          settings = {
             vue = {
                version = 2, 
             }
          }
        },
      },
      
      setup = {
        vtsls = function(_, opts) return nil end, -- Enable vtsls
        ts_ls = function() return true end, -- Disable ts_ls
        volar = function(_, opts) return nil end, -- Enable volar
        vue_ls = function() return true end, -- Disable deprecated
      },
    },
  },
}

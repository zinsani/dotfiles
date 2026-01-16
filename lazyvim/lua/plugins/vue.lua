-- Vue 2.7 LSP configuration (Takeover Mode)
-- This file is only active for Vue projects; otherwise returns empty config

local function is_vue_project()
  local cwd = vim.fn.getcwd()

  -- .vue files in src/ or root
  local vue_files = vim.fn.glob(cwd .. "/src/**/*.vue", false, true)
  if #vue_files == 0 then
    vue_files = vim.fn.glob(cwd .. "/*.vue", false, true)
  end
  if #vue_files > 0 then
    return true
  end

  -- package.json has vue dependency
  local package_json_path = cwd .. "/package.json"
  if vim.fn.filereadable(package_json_path) == 1 then
    local content = vim.fn.readfile(package_json_path)
    local json_str = table.concat(content, "\n")
    if json_str:match('"vue"%s*:') or json_str:match('"@vue/') then
      return true
    end
  end

  -- Vue config files
  if
    vim.fn.filereadable(cwd .. "/vue.config.js") == 1
    or vim.fn.filereadable(cwd .. "/vue.config.ts") == 1
    or vim.fn.filereadable(cwd .. "/vetur.config.js") == 1
  then
    return true
  end

  -- vite.config with vue plugin
  local vite_configs = { "/vite.config.ts", "/vite.config.js", "/vite.config.mts" }
  for _, config in ipairs(vite_configs) do
    local vite_path = cwd .. config
    if vim.fn.filereadable(vite_path) == 1 then
      local vite_content = vim.fn.readfile(vite_path)
      local vite_str = table.concat(vite_content, "\n")
      if vite_str:match("@vitejs/plugin%-vue") or vite_str:match("vite%-plugin%-vue") then
        return true
      end
    end
  end

  return false
end

-- Early exit: Not a Vue project → return empty config, let LazyVim defaults work
if not is_vue_project() then
  return {}
end

-- Vue project: Configure vue_ls in Takeover Mode
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vuels = { enabled = false },
        vtsls = { enabled = false },
        ts_ls = { enabled = false },
        volar = { enabled = false },

        vue_ls = {
          enabled = true,
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
          init_options = {
            vue = {
              hybridMode = false,
            },
            typescript = {
              tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
            },
          },
          on_init = function()
            return true
          end,
        },
      },
      setup = {
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

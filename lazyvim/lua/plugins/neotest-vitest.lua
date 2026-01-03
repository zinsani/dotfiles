return {
  "nvim-neotest/neotest",
  dependencies = {
    "marilari88/neotest-vitest",
  },
  opts = {
    log_level = vim.log.levels.DEBUG,
    adapters = {
      ["neotest-vitest"] = {
        -- filter_dir to exclude node_modules
        filter_dir = function(name)
          return name ~= "node_modules"
        end,
      },
    },
  },
}

return {
  "nvim-neotest/neotest",
  dependencies = {
    "marilari88/neotest-vitest",
  },
  opts = {
    log_level = vim.log.levels.DEBUG,
    summary = {
      open = "botright vsplit | vertical resize " .. math.floor(vim.o.columns * 0.4),
    },
    output_panel = {
      open = "botright vsplit | vertical resize " .. math.floor(vim.o.columns * 0.4),
    },
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

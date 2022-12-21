local status, svelte_plugin = pcall(require, "vim-svelte-plugin")
if (not status) then return end

local status2, svelte = pcall(require, "vim-svelte")
if (not status2) then return end


local status3, svelte_theme = pcall(require, "vim-svelte-theme")
if (not status3) then return end

svelte_plugin.setup {}

svelte.setup {}

svelte_theme.setup {}

vim.opt.svelte_plugin_use_typescript = 1
vim.opt.svelte_plugin_use_sass = 1
vim.opt.svelte_plugin_has_init_indent = 2
vim.opt.svelte_preprocessor_tags = { { name = 'typescript', tag = 'script', as = 'typescript' } }
vim.opt.svelte_preprocessors = { 'typescript' }

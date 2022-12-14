local status, svelte_plugin = pcall(require, "vim-svelte-plugin")
if (not status) then return end

local status2, svelte = pcall(require, "vim-svelte")
if (not status2) then return end


svelte_plugin.setup {}

svelte.setup {}

vim.opt.svelte_plugin_use_typescript = 1
vim.opt.svelte_plugin_use_sass = 1
vim.opt.svelte_preprocessor_tags = {{ name = 'typescript', tag = 'script', as = 'typescript' }}
vim.opt.svelte_preprocessors = { 'typescript' }

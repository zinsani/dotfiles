local status, mason = pcall(require, "mason")
if (not status) then return end
mason.setup()

local status2, mason_lspconfig = pcall(require, "mason-lspconfig")
if (not status2) then return end

mason_lspconfig.setup({
	ensure_installed = { "sumneko_lua", "rust_analyzer", "tsserver", "svelte", "omnisharp", "clangd", "cssls",
		"quick_lint_js", "marksman", "powershell_es", "sqlls", "vuels", "yamlls" }
})


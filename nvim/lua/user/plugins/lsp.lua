-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')
-- local ih = require('inlay-hints')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { "lua_ls", "rust_analyzer", "tsserver", "svelte", "omnisharp", "clangd", "cssls",
	"marksman", "sqlls", "yamlls", "volar", "emmet_ls" }
local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

local runtime_path = {
	"?.lua",
	"?/init.lua",
	"?/?.lua",
	"~/.luarocks/share/lua/5.3/?.lua",
	"~/.luarocks/share/lua/5.3/?/init.lua",
	"/usr/share/5.3/?.lua",
	"/usr/share/lua/5.3/?/init.lua"
}

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

	-- format on save
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("Format", { clear = true }),
			buffer = bufnr,
			callback = function() vim.lsp.buf.format() end
		})
	end

	-- ih.on_attach(client, bufnr)
end

for _, lsp in ipairs(servers) do
	if (lsp == 'typescript') then
		lspconfig.tsserver.setup {
			on_attach = on_attach,
			capabilities = capabilities,
			flags = lsp_flags,
			filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
			root_dir = function() return vim.loop.cwd() end,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = 'all',
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					}
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = 'all',
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					}
				}
			}
		}
	elseif (lsp == 'volar') then
		lspconfig.volar.setup {
			on_attach = function(client, bufnr)
				client.server_capabilities.document_formatting = false
				client.server_capabilities.document_range_formatting = false
				client.server_capabilities.documentFormattingProvider = false
				return on_attach(client, bufnr)
			end,
		}
	elseif (lsp == 'omnisharp') then
		local pid = vim.fn.getpid()
		local omnisharp_bin = vim.fn.has('win32') == 0 and
				vim.fn.environ()['HOME'] .. "/.local/share/nvim/mason/packages/omnisharp/OmniSharp" or
				vim.fn.environ()['HOMEDRIVE'] .. vim.fn.environ()['HOMEPATH'] .. '/scoop/apps/omnisharp/current/OmniSharp.exe'
		lspconfig.omnisharp.setup {
			cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
			on_attach = on_attach,
			flags = lsp_flags
		}
	elseif (lsp == "lua_ls") then
		lspconfig.lua_ls.setup {
			on_attach = on_attach,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
						-- Setup your lua path
						path = runtime_path,
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
				},
			},
		}
	elseif (lsp == "emmet_ls") then
		-- Emmet
		lspconfig.emmet_ls.setup({
			capabilities = capabilities,
			filetypes = {
				"css",
				"html",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"typescriptreact",
			},
		})
	else
		lspconfig[lsp].setup {
			on_attach = on_attach,
			capabilities = capabilities,
			flags = lsp_flags
		}
	end
end




---------------------------------
-- Floating diagnostics message
---------------------------------
vim.diagnostic.config({
	float = { source = "always", border = border },
	virtual_text = false,
	signs = true,
})

---------------------------------
-- Auto commands
---------------------------------
vim.cmd([[ autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

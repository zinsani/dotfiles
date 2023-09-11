local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- vim.cmd [[packadd packer.nvim]]

local status, packer = pcall(require, "packer")

if (not status) then
	print("Packer is not installed")
	return
end
return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	-- Your plugins go here
	-- Simple plugins can be specified as strings

	use 'nvim-lua/plenary.nvim'
	use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
	use 'L3MON4D3/LuaSnip'        -- Snippets plugin
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	use { 'jose-elias-alvarez/null-ls.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }
	use 'MunifTanjim/prettier.nvim'
	-- use { 'numToStr/prettierrc.nvim',
	-- 	config = function()
	-- 		require("prettierrc").setup {}
	-- 	end
	-- }
	use {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	}
	use 'mhartington/formatter.nvim'
	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	use 'hrsh7th/cmp-buffer'  -- LSP source for buffer
	use 'hrsh7th/cmp-path'    -- LSP source for path
	use 'hrsh7th/cmp-cmdline' -- LSP source for cmdline
	use 'hrsh7th/nvim-cmp'    -- Autocompletion plugin
	use {
		"mattn/emmet-vim",
		config = function ()
			vim.g.user_emmet_leader_key = '<C-y>'

			vim.g.user_emmet_settings = {
				indent_blockelement = 1,
			}
		end
	}
	-- use { 'sbdchd/neoformat',
	-- 	config = function()
	-- 		require('neoformat').setup()
	-- 	end
	-- }
	use 'simrat39/inlay-hints.nvim'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }
	use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { { 'nvim-lua/plenary.nvim' } } }
	use "nvim-telescope/telescope-file-browser.nvim"
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup {}
		end
	})
	use "tpope/vim-commentary"
	use "JoosepAlviste/nvim-ts-context-commentstring"
	use "ellisonleao/gruvbox.nvim"
	use "leafgarland/typescript-vim"
	use "leafOfTree/vim-svelte-plugin"
	use 'othree/html5.vim'
	use 'pangloss/vim-javascript'
	use { 'evanleck/vim-svelte', branch = 'main' }
	use 'tpope/vim-fugitive'
	use 'windwp/nvim-autopairs'
	use {
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	}
	if packer_bootstrap then
		require('packer').sync()
	end
end)

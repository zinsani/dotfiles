print('packer module')

local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- Your plugins go here
  -- Simple plugins can be specified as strings
    
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
	use { 'jose-elias-alvarez/null-ls.nvim', requires = { {'nvim-lua/plenary.nvim'} } }
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
 	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { {'nvim-lua/plenary.nvim'} } }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use({
      "kylechui/nvim-surround",
      tag = "*", -- Use for stability; omit to use `main` branch for the latest features
      config = function()
          require("nvim-surround").setup{}
      end
  })
  use { "ellisonleao/gruvbox.nvim" }
	use { "leafOfTree/vim-svelte-plugin" }
  use { 'tpope/vim-fugitive' }  
  use { 'windwp/nvim-autopairs' }  
end)

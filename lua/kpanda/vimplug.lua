local Plug = vim.fn["plug#"]

vim.call("plug#begin")
--Themes
Plug("navarasu/onedark.nvim")
-- Plug 'ellisonleao/gruvbox.nvim'
Plug("rebelot/kanagawa.nvim")

Plug("nvim-treesitter/nvim-treesitter", {
	["do"] = function()
		vim.cmd(":TSUpdate")
	end,
})

Plug("windwp/nvim-autopairs")
Plug("windwp/nvim-ts-autotag")

-- LSP Support
Plug("neovim/nvim-lspconfig")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")

-- Formatting
Plug("lukas-reineke/lsp-format.nvim")
Plug("jose-elias-alvarez/null-ls.nvim")

-- Autocompletion
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("saadparwaiz1/cmp_luasnip")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-nvim-lua")

Plug("VonHeikemen/lsp-zero.nvim", { branch = "v1.x" })

Plug("nvim-lua/plenary.nvim")
Plug("folke/snacks.nvim")
Plug("nvim-lualine/lualine.nvim")

Plug("lewis6991/gitsigns.nvim")

Plug("kyazdani42/nvim-web-devicons")
Plug("kyazdani42/nvim-tree.lua")

Plug("tpope/vim-fugitive")
Plug("tpope/vim-surround")
Plug("tpope/vim-sleuth")

-- Color preview
Plug("catgoose/nvim-colorizer.lua")

vim.call("plug#end")

local Plug = vim.fn["plug#"]

vim.call("plug#begin", "/home/kpanda/.config/nvim/plugged")
--Themes
Plug("rebelot/kanagawa.nvim")

Plug("nvim-treesitter/nvim-treesitter", {
	["do"] = function()
		vim.cmd(":TSUpdate")
	end,
})

Plug("windwp/nvim-autopairs")

-- LSP Support
Plug("williamboman/mason.nvim")

-- Formatting
Plug("lukas-reineke/lsp-format.nvim")
Plug("nvimtools/none-ls.nvim")

-- Autocompletion
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("saadparwaiz1/cmp_luasnip")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-nvim-lua")

Plug("nvim-lua/plenary.nvim")
Plug("nvim-lualine/lualine.nvim")

Plug("folke/snacks.nvim")

Plug("lewis6991/gitsigns.nvim")

Plug("kyazdani42/nvim-web-devicons")

Plug("tpope/vim-fugitive")
Plug("tpope/vim-surround")
Plug("tpope/vim-sleuth")

vim.call("plug#end")

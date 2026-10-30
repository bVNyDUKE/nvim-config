local gh = function(x)
	return "https://github.com/" .. x
end

vim.pack.add({
	-- Themes
	gh("rebelot/kanagawa.nvim"),

	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },

	gh("windwp/nvim-autopairs"),
	gh("windwp/nvim-ts-autotag"),

	-- LSP Support
	gh("mason-org/mason.nvim"),
	gh("neovim/nvim-lspconfig"),

	-- Formatting
	gh("stevearc/conform.nvim"),

	-- Autocompletion
	{ src = gh("echasnovski/mini.icons"), version = "stable" },
	{ src = gh("echasnovski/mini.completion"), version = "stable" },

	gh("folke/snacks.nvim"),
	gh("lewis6991/gitsigns.nvim"),

	gh("tpope/vim-fugitive"),
	gh("tpope/vim-surround"),
})

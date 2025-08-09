local Plug = vim.fn["plug#"]

vim.call("plug#begin", "~/.config/nvim/plugged")
--Themes
Plug("rebelot/kanagawa.nvim")

Plug("nvim-treesitter/nvim-treesitter", {
	["do"] = function()
		vim.cmd(":TSUpdate")
	end,
})

Plug("windwp/nvim-autopairs")

-- LSP Support
Plug("mason-org/mason.nvim")
Plug("neovim/nvim-lspconfig")

-- Formatting
-- Plug("lukas-reineke/lsp-format.nvim")
Plug("nvimtools/none-ls.nvim")

-- Autocompletion
Plug("echasnovski/mini.icons", { branch = "stable" })
Plug("echasnovski/mini.completion", { branch = "stable" })

Plug("nvim-lua/plenary.nvim")

Plug("folke/snacks.nvim")

Plug("lewis6991/gitsigns.nvim")

Plug("tpope/vim-fugitive")
Plug("tpope/vim-surround")

vim.call("plug#end")

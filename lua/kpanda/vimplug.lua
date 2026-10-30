local Plug = vim.fn["plug#"]

vim.call("plug#begin", "~/.config/nvim/plugged")
--Themes
Plug("rebelot/kanagawa.nvim")

Plug("nvim-treesitter/nvim-treesitter", { branch = "main", ["do"] = ":TSUpdate" })

Plug("windwp/nvim-autopairs")
Plug("windwp/nvim-ts-autotag")

-- LSP Support
Plug("mason-org/mason.nvim")
Plug("neovim/nvim-lspconfig")

-- Formatting
Plug("stevearc/conform.nvim")

-- Autocompletion
Plug("echasnovski/mini.icons", { branch = "stable" })
Plug("echasnovski/mini.completion", { branch = "stable" })

Plug("folke/snacks.nvim")
Plug("lewis6991/gitsigns.nvim")

Plug("tpope/vim-fugitive")
Plug("tpope/vim-surround")

vim.call("plug#end")

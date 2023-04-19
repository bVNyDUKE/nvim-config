local Plug = vim.fn['plug#']

vim.call('plug#begin', '/home/kpanda/.config/nvim/plugged')
--Themes
Plug 'AlexvZyl/nordic.nvim'
Plug 'navarasu/onedark.nvim'
Plug('folke/tokyonight.nvim', { branch = 'main' })
Plug('catppuccin/nvim', { as = 'catppuccin' })
Plug 'rose-pine/neovim'
Plug 'rebelot/kanagawa.nvim'
Plug "ellisonleao/gruvbox.nvim"
-- Plug 'sainnhe/gruvbox-material'


Plug 'mrshmllow/document-color'
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = function()
  vim.cmd(':TSUpdate')
end
})

Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'echasnovski/mini.pairs'

-- LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

-- Formatting
Plug 'lukas-reineke/lsp-format.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'

-- Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'

--  Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

Plug('VonHeikemen/lsp-zero.nvim', {branch = 'v1.x'})

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'WhoIsSethDaniel/lualine-lsp-progress.nvim'

Plug 'lewis6991/gitsigns.nvim'
Plug 'lewis6991/impatient.nvim'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

vim.call('plug#end')

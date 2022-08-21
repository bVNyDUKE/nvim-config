local Plug = vim.fn['plug#']

vim.call('plug#begin','/home/kpanda/.config/nvim/plugged')
  --Themes
--Plug 'dracula/vim'
--Plug('sonph/onehalf', {rtp = 'vim/'})
  Plug 'EdenEast/nightfox.nvim'
  Plug('nvim-treesitter/nvim-treesitter', {['do'] = function()
    vim.cmd(':TSUpdate')
    end
  })
  Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = function()
    vim.cmd('cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build')
   end
   })
  --LSP
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'onsails/lspkind-nvim'
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
  Plug 'neovim/nvim-lspconfig'
  Plug('glepnir/lspsaga.nvim', { branch = 'main' })

  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'airblade/vim-gitgutter'
  Plug('akinsho/toggleterm.nvim', { tag = 'v1.*'})
  Plug('lukas-reineke/indent-blankline.nvim', {branch = 'lua'})

  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'

vim.call('plug#end')

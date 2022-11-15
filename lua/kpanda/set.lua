local set = vim.opt

set.compatible     = false -- disable compatibility to old-time vi
set.showmatch      = true --show matching
set.ignorecase     = true --case insensitive
set.smartcase      = true
set.hlsearch       = false -- highlight search
set.incsearch      = true -- incremental search
set.tabstop        = 2 -- number of columns occupied by a tab
set.softtabstop    = 2 -- see multiple spaces as tabstops so <BS> does the right thing
set.shiftwidth     = 2 -- width for autoindents
set.expandtab      = true -- converts tabs to white space
set.smarttab       = true
set.errorbells     = false
set.wrap           = false
set.hidden         = true
set.number         = true -- add line numbers
set.relativenumber = true -- relative line numbers
set.wildmode       = "longest,list" -- get bash-like tab completions
set.mouse          = "a" -- enable mouse click
set.clipboard      = "unnamedplus" -- using system clipboard
set.ttyfast        = true -- Speed up scrolling in Vim
set.splitright     = true
set.splitbelow     = true
set.encoding       = "UTF-8"
set.scrolloff      = 8
set.signcolumn     = "yes"
set.updatetime     = 40
set.completeopt    = "menuone,noinsert,noselect"
set.termguicolors  = true
set.pumheight      = 10
vim.cmd [[
  filetype plugin indent on
  filetype plugin on
  syntax on
  ]]

vim.g.mapleader = " "

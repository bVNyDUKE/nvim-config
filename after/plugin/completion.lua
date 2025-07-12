require("mini.completion").setup()

vim.cmd([[set completeopt+=menuone,noselect,popup]])
vim.cmd([[au FileType snacks_picker_input lua vim.b.minicompletion_disable = true]])
vim.cmd([[au FileType snacks_input lua vim.b.minicompletion_disable = true]])

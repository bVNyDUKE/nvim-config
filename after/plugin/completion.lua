require("mini.completion").setup()

vim.opt.completeopt = { "noinsert", "menuone", "fuzzy", "noselect" }
vim.cmd([[au FileType snacks_picker_input lua vim.b.minicompletion_disable = true]])
vim.cmd([[au FileType snacks_input lua vim.b.minicompletion_disable = true]])

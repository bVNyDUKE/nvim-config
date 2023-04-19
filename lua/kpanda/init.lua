require('kpanda.set')
require('kpanda.vimplug')
require('impatient')
require('kpanda.telescope')
require("gruvbox").setup({
  contrast = "hard",
  inverse = true,
  overrides = {
    LineNr = { fg = "grey" }
  },
  palette_overrides={
    bright_red = "#de5050"
  }
})

vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

-- vim.cmd("colorscheme gruvbox-material")
-- vim.g.gruvbox_material_background = "hard"
-- vim.g.gruvbox_material_better_performance = 1
-- vim.cmd("colorscheme catppuccin-mocha")
-- vim.cmd[[hi LineNr guifg=grey]]



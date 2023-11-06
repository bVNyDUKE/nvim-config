require('kpanda.set')
require('kpanda.vimplug')
require('impatient')
require('kpanda.telescope')
require('kanagawa').setup({
  colors = {
      theme = {
          all = {
              ui = {
                  nontext  = "grey"
              }
          }
      }
  }
})

require("gruvbox").setup({
  contrast = "hard",
  inverse = true,
  overrides = {
    LineNr = { fg = "grey" }
  },
  palette_overrides = {
    bright_red = "#de5050"
  }
})

-- vim.o.background = "dark"
-- vim.cmd("colorscheme gruvbox")
vim.cmd("colorscheme kanagawa")

-- vim.cmd("let g:sonokai_style = 'andromeda'")
-- vim.o.background="dark"

-- vim.cmd("colorscheme sonokai")
-- vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#b1b1b1', bold=false })
-- vim.api.nvim_set_hl(0, 'LineNr', { fg='#b1b1b1', bold=false })
-- vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#b1b1b1', bold=false })

-- vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#b4befe', bold=false })
-- vim.api.nvim_set_hl(0, 'LineNr', { fg='#f5c2e7', bold=false })
-- vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#b4befe', bold=false })


local Remap = require("kpanda.keymap")
local nnoremap = Remap.nnoremap

require("nvim-tree").setup({
  hijack_netrw = false,
  git = {
      enable = false
  },
  view = {
    float = {
      enable = true,
      open_win_config = {
      width = 60,
      height = 60,
      row = 3,
      col = 3,
      }
    }
  }
})

nnoremap('<leader>t', '<Cmd>NvimTreeToggle<CR>')

local Remap = require("kpanda.keymap")
local nnoremap = Remap.nnoremap

require("nvim-tree").setup()

nnoremap('<C-b>', '<Cmd>NvimTreeToggle<CR>')

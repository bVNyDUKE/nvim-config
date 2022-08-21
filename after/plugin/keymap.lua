local Remap = require("kpanda.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

inoremap('jj', '<Esc>')
nnoremap(';' ,':')
nnoremap('<leader>w', '<Cmd>update<CR>')
nnoremap('<c-x>', ':Ex<CR>')


local Remap = require("kpanda.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

inoremap('jj', '<Esc>')
nnoremap('<leader>w', '<Cmd>update<CR>')
nnoremap('<c-x>', ':Ex<CR>')
nnoremap('<C-w>tn', ':tabnew<CR>')
nnoremap('<C-w>1', '1gt')
nnoremap('<C-w>2', '2gt')
nnoremap('<C-w>3', '3gt')
nnoremap('<C-w>4', '4gt')
nnoremap('<C-w>5', '5gt')

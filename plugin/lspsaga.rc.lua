require('lspsaga').setup({
  server_filetype_map = {
    typescript = 'typescript'
  },
  lightbulb = {
    enable = true,
    sign = true,
    virtual_text = false,
  },
  symbol_in_winbar = {
    enable = true
  },
  ui = {
    border = 'double',
  }
})

vim.keymap.set('n', ']g', '<Cmd>Lspsaga diagnostic_jump_next<CR>')
vim.keymap.set('n', '[g', '<Cmd>Lspsaga diagnostic_jump_prev<CR>')
vim.keymap.set({'n', 'v'}, '<leader>ca', '<cmd>Lspsaga code_action<CR>')
vim.keymap.set('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>')
vim.keymap.set({'n', 't'}, '<C-t>', '<Cmd>Lspsaga term_toggle<CR>')

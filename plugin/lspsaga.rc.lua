local status, saga = pcall(require, "lspsaga")
if (not status) then return end

saga.init_lsp_saga {
  server_filetype_map = {
    typescript = 'typescript'
  },
  code_action_lightbulb = {
    enable = false
  },
  symbol_in_winbar = {
    enable = true
  }
}

local opts = { noremap = true, silent = true }
vim.keymap.set('n', ']g', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n', '[g', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
vim.keymap.set('n', 'gh', '<Cmd>Lspsaga hover_doc<CR>', opts)
vim.keymap.set('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>', opts)

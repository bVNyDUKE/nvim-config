vim.opt.list = true
vim.opt.listchars:append("space:⋅")

require("indent_blankline").setup {
  char = '|',
  context_char = '|',
  enabled = true,
  show_current_context = true,
  show_current_context_start = false,
  show_end_of_line = true,
}

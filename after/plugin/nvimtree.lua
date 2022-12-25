require("nvim-tree").setup({
  hijack_netrw = false,
  git = {
    enable = false
  },
  view = {
    side = "right",
    number = true,
    relativenumber = true,
    hide_root_folder = true,
  },
  diagnostics = {
    enable = true
  }
})

vim.keymap.set("n", '<leader>e', '<Cmd>NvimTreeToggle<CR>')

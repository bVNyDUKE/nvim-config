require("nvim-tree").setup({
  hijack_netrw = false,
  git = {
    enable = false
  },
  view = {
    side = "right",
    number = true,
    relativenumber = true,
    width = 50
  },
  diagnostics = {
    enable = true
  },
  renderer = {
    root_folder_label = false
  }
})

vim.keymap.set("n", '<leader>e', '<Cmd>NvimTreeToggle<CR>')

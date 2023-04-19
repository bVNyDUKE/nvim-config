require("nvim-tree").setup({
  hijack_netrw = false,
  renderer = {
    root_folder_label = false
  },
  git = {
    enable = true
  },
  view = {
    side = "right",
    number = true,
    relativenumber = true,
    width = {
      min = 50,
      max = 150
    }
  },
  diagnostics = {
    enable = true
  }
})

vim.keymap.set("n", '<leader>e', '<Cmd>NvimTreeToggle<CR>')

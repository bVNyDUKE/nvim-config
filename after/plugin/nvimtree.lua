require("nvim-tree").setup({
  hijack_netrw = false,
  git = {
    enable = true
  },
  view = {
    side = "right",
    number = true,
    relativenumber = true,
    hide_root_folder = true,
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

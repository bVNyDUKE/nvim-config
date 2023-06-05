-- function telescope_buffer_dir()
--   return vim.fn.expand('%:p:h')
-- end

local actions = require('telescope.actions')

require("telescope").setup{
  defaults = {
      layout_strategy = "vertical",
      file_ignore_patterns = {
          "node_modules",
          "vendor",
        },
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  }
}

vim.keymap.set('n','<leader>p', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n','<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n','<leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n','<leader>fd', '<cmd>Telescope diagnostics<cr>')
vim.keymap.set('n','<leader>fh', '<cmd>Telescope help_tags<cr>')

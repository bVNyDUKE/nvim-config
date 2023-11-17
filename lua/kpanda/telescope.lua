-- function telescope_buffer_dir()
--   return vim.fn.expand('%:p:h')
-- end

local actions = require('telescope.actions')

require("telescope").setup{
  defaults = {
      layout_strategy = "vertical",
      preview_cutoff = 20,
      file_ignore_patterns = {
          "node_modules",
          "vendor",
        },
    mappings = {
      n = {
        ["q"] = actions.close,
        ["<c-d>"] = actions.delete_buffer,
      },
    },
  },
  pickers = {
    lsp_references = {
      fname_width = 60,
      include_current_line = true,
      include_declaration = false,
      jump_type = "tab"
    }
  }
}

vim.keymap.set('n','<leader>p', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n','<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n','<leader>fb', '<cmd>Telescope git_branches<cr>')
vim.keymap.set('n','<leader>fd', '<cmd>Telescope diagnostics<cr>')
vim.keymap.set('n','<leader>fh', '<cmd>Telescope help_tags<cr>')
vim.keymap.set('n','<leader>ff', '<cmd>Telescope buffers<cr>')

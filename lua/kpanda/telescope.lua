function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local actions = require('telescope.actions')

require("telescope").setup{
  defaults = {
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

local nnoremap = require("kpanda.keymap").nnoremap
nnoremap('<c-p>', '<cmd>Telescope find_files<cr>')
nnoremap('<leader>fg', '<cmd>Telescope live_grep<cr>')
nnoremap('<leader>fb', '<cmd>Telescope buffers<cr>')
nnoremap('<leader>fh', '<cmd>Telescope help_tags<cr>')

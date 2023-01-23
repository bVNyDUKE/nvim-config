require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "lua",
    "javascript",
    "tsx",
    "json",
    "python",
    "markdown",
    "rust",
    "vim",
    "yaml",
    "toml",
    "typescript",
    "vue",
    "css",
    "phpdoc",
    "html",
    "php",
    "prisma"
  },
  sync_install = false,
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  autotag = {
    enable = true,
  }
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

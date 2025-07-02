require("nvim-treesitter.configs").setup({
	ignore_install = {},
	modules = {},
	auto_install = false,
	ensure_installed = { "lua", "javascript", "typescript", "vue", "css", "html" },
	sync_install = false,
	highlight = {
		enable = true,
		disable = {},
	},
	indent = {
		enable = true,
		disable = {},
	},
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

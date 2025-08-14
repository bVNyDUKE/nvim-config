require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = "",
		section_separators = "",
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = { {
			"filename",
			path = 1,
		} },
		lualine_x = { "diagnostics", "encoding", "filetype" },
		lualine_y = { "lsp_status" },
		lualine_z = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})

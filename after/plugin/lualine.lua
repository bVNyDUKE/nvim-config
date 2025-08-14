require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = "",
		section_separators = "",
		always_divide_middle = true,
		always_show_tabline = false,
		globalstatus = true,
	},
	sections = {
		lualine_a = {},
		lualine_b = { "branch", "diff" },
		lualine_c = { {
			"filename",
			path = 1,
		} },
		lualine_x = {
			{
				"diagnostics",
				symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
			},
			"encoding",
			{ "filetype", icon_only = true },
		},
		lualine_y = {},
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
	tabline = {
		lualine_a = { { "tabs", mode = 2 } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = {},
})

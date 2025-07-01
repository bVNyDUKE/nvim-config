require("colorizer").setup({
	filetypes = { "css", "vue", "javascript" },
	user_default_options = {
		tailwind = true,
		css = true,
		css_fn = true,
		RRGGBBAA = true,
		-- hooks = {
		-- 	disable_line_highlight = function(line, bufnr, line_num)
		-- 		return string.sub(line, 1, 2) ~= "--"
		-- 	end,
		-- },
	},
})

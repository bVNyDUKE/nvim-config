require("kpanda.set")
require("kpanda.pack")

require("kanagawa").setup({
	theme = "wave",
	compile = true,
	overrides = function(colors)
		local theme = colors.theme
		return {
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
			StatusLine = { fg = theme.ui.fg_dim, bg = theme.ui.bg },
		}
	end,
})
vim.cmd("colorscheme kanagawa")

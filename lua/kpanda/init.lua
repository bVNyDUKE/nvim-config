require("kpanda.set")
require("kpanda.vimplug")

require("kanagawa").setup({
	theme = "wave",
	compile = true,
	overrides = function()
		return {
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
		}
	end,
})
vim.cmd("colorscheme kanagawa")

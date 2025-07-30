vim.loader.enable()
require("kpanda.set")
require("kpanda.vimplug")

require("kanagawa").setup({
	theme = "wave",
	overrides = function()
		return {
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
		}
	end,
})
vim.cmd("colorscheme kanagawa")

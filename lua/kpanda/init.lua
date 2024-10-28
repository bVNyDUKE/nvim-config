require("kpanda.set")
require("kpanda.vimplug")
require("kpanda.telescope")

-- require("gruvbox").setup({
--   contrast = "hard",
--   inverse = true,
--   overrides = {
--     LineNr = { fg = "grey" }
--   },
--   palette_overrides = {
--     bright_red = "#de5050"
--   }
-- })

require("kanagawa").setup({
	colors = {
		theme = {
			all = {
				ui = {
					nontext = "grey",
				},
			},
		},
	},
	overrides = function()
		return {
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
		}
	end,
})

vim.cmd("colorscheme kanagawa")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = vim.api.nvim_create_augroup("k-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

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

require("onedark").setup({
	style = "light",
	colors = {
		bg0 = "#f1efee",
	},
})

local time = os.date("*t")
if (time.hour > 6) and (time.hour < 18) then
	vim.cmd("colorscheme onedark")
else
	vim.cmd("colorscheme kanagawa")
end

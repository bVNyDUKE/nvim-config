require("kpanda.set")
require("kpanda.vimplug")
require("impatient")
require("kpanda.telescope")

--vim.cmd("colorscheme monokai-pro")
--vim.cmd("colorscheme github_dark_dimmed")

-- require("gruvbox").setup({
--   contrast = "hard",
--   inverse = true,
--   overrides = {
--     LineNr = { fg = "grey" },
--   },
--   palette_overrides={
--     bright_red = "#de5050"
--   }
-- })
-- vim.o.background = "dark"
-- vim.cmd("colorscheme gruvbox")

vim.cmd("colorscheme kanagawa")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = vim.api.nvim_create_augroup("k-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

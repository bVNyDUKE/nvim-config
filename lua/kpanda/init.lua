require("kpanda.set")
require("kpanda.vimplug")
require("kpanda.snacks")
require("kpanda.terminal")
require("kpanda.theme")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = vim.api.nvim_create_augroup("k-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

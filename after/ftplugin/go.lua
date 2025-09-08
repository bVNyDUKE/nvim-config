vim.opt_local.tabstop = 8
vim.opt_local.shiftwidth = 8
vim.opt_local.textwidth = 79
vim.opt_local.autoindent = true

vim.keymap.set({ "i", "n" }, "<C-e>", function()
	vim.cmd("norm! oif err != nil {")
	vim.cmd("norm! o\t")
	vim.cmd("norm! o}")
	vim.cmd("norm! k")
	vim.cmd("startinsert!")
end)

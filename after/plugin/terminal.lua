vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-termopen", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})

vim.keymap.set("n", "<leader>st", "<Cmd>botright 20split | term<CR>")

vim.keymap.set("t", "jj", "<C-\\><C-N>")

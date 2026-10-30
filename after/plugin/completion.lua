require("mini.completion").setup({
	lsp_completion = { source_func = "omnifunc", auto_setup = false },
	delay = { completion = 200, info = 200, signature = 100 },
})

vim.opt.completeopt = { "noinsert", "menuone", "noselect" }
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("custom-minicompletion-disable", { clear = true }),
	pattern = { "snacks_picker_input", "snacks_input" },
	callback = function()
		vim.b.minicompletion_disable = true
	end,
})

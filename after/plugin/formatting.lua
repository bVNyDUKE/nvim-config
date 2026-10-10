local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		vue = { "prettier" },
	},
	format_on_save = {
		timeout_ms = 1000,
	},
})

vim.keymap.set("n", "<leader>bf", function()
	conform.format({ lsp_format = "fallback" })
end)

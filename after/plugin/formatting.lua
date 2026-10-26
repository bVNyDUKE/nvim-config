require("conform").setup({
	formatters_by_ft = {
		go = { "gofmt" },
		lua = { "stylua" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		vue = { "prettier" },
	},
	format_on_save = {
		timeout_ms = 500,
	},
})

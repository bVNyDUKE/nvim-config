vim.opt_local.tabstop = 8
vim.opt_local.shiftwidth = 8
vim.opt_local.textwidth = 79
vim.opt_local.autoindent = true

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	root_markers = { "go.mod" },
	filetypes = { "go" },
	settings = {
		gopls = {
			usePlaceholders = true,
			codelenses = {
				gc_details = true,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			experimentalPostfixCompletions = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-node_modules" },
			semanticTokens = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})

vim.lsp.enable("gopls")

local lsp = require("lsp-zero")
local autopairs = require("nvim-autopairs")
local nvim_lsp = require("lspconfig")

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
})

lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
})

lsp.configure("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- lsp.configure('eslint',{
--   working_directories = {"./frontend"}
-- })

lsp.configure("tsserver", {
	root_dir = nvim_lsp.util.root_pattern("package.json"),
})

lsp.on_attach(function(_, bufnr)
	lsp.default_keymaps({ bufnr = bufnr })
	local map = function(keys, func)
		vim.keymap.set("n", keys, func, { buffer = bufnr, remap = false })
	end
	map("]g", vim.diagnostic.goto_next)
	map("[g", vim.diagnostic.goto_prev)
	map("<leader>ca", vim.lsp.buf.code_action)
	map("K", vim.lsp.buf.hover)
	map("gR", vim.lsp.buf.rename)
	map("gr", require("telescope.builtin").lsp_references)
	map("gd", require("telescope.builtin").lsp_definitions)
	map("<leader>ds", require("telescope.builtin").lsp_document_symbols)
end)

lsp.setup()

autopairs.setup({})

local null_ls = require("null-ls")
local null_opts = lsp.build_options("null-ls", {})
null_ls.setup({
	on_attach = function(client, bufnr)
		null_opts.on_attach(client, bufnr)

		require("lsp-format").on_attach(client)

		if client.server_capabilities.colorProvider then
			require("document-color").buf_attach(bufnr)
		end
	end,

	-- Vue setup:
	-- prettierd - only local
	-- NextJs setup:
	-- prettierd - default
	sources = {
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.code_actions.eslint,
		null_ls.builtins.formatting.eslint,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier.with({
			only_local = "node_modules/.bin",
			disabled_filetypes = { "vue" },
			extra_filetypes = { "astro" },
		}),
	},
})

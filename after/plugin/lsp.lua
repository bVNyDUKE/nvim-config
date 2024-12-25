require("mason").setup()
require("mason-lspconfig").setup()
local lsp = require("lsp-zero")
local nvim_lsp = require("lspconfig")

lsp.preset("recommended")

lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
	set_lsp_keymaps = false,
})

lsp.configure("denols", {
	root_dir = nvim_lsp.util.root_pattern("deno.json"),
})

lsp.configure("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.stdpath("config") .. "/lua",
				},
				maxPreload = 1000,
				preloadFileSize = 500,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

lsp.configure("pyright", {
	settings = {
		python = {
			analysis = {
				useLibraryCodeForType = true,
			},
		},
	},
})

-- lsp.configure('eslint',{
--   working_directories = {"./frontend"}
-- })
--
local js_inlay_hints = {
	inlayHints = {
		includeInlayEnumMemberValueHints = true,
		includeInlayFunctionLikeReturnTypeHints = true,
		includeInlayFunctionParameterTypeHints = true,
		includeInlayParameterNameHints = "all",
		includeInlayParameterNameHintsWhenArgumentMatchesName = false,
		includeInlayPropertyDeclarationTypeHints = true,
		includeInlayVariableTypeHints = true,
	},
}
lsp.configure("ts_ls", {
	root_dir = nvim_lsp.util.root_pattern("package.json"),
	settings = {
		typescript = js_inlay_hints,
		javascript = js_inlay_hints,
	},
})

local toggle_inlay_hints = function()
	local enabled = vim.lsp.inlay_hint.is_enabled({ nil })
	local state = "Enabled"
	if enabled then
		state = "Disabled"
	end
	vim.lsp.inlay_hint.enable(not enabled)
	print(string.format("%s inlay hints", state))
end

lsp.on_attach(function(_, bufnr)
	lsp.default_keymaps({ bufnr = bufnr })
	local map = function(keys, func)
		vim.keymap.set("n", keys, func, { buffer = bufnr, remap = false })
	end
	map("]g", vim.diagnostic.goto_next)
	map("[g", vim.diagnostic.goto_prev)
	map("<leader>ca", vim.lsp.buf.code_action)
	map("gR", vim.lsp.buf.rename)
	map("gr", require("telescope.builtin").lsp_references)
	map("gd", require("telescope.builtin").lsp_definitions)
	map("<leader>ds", require("telescope.builtin").lsp_document_symbols)
	map("<leader>i", toggle_inlay_hints)
end)

lsp.setup()

require("nvim-autopairs").setup({
	fast_wrap = {},
})

local null_ls = require("null-ls")
local null_opts = lsp.build_options("null-ls", {})
null_ls.setup({
	on_attach = function(client, bufnr)
		null_opts.on_attach(client, bufnr)

		require("lsp-format").on_attach(client)
	end,

	-- Vue setup:
	-- prettierd - only local
	-- NextJs setup:
	-- prettierd - default
	sources = {
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.code_actions.eslint.with({
			env = {
				ESLINT_USE_FLAT_CONFIG = false,
			},
		}),
		null_ls.builtins.formatting.eslint,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier.with({
			only_local = "node_modules/.bin",
			disabled_filetypes = { "vue", "html", "yml", "yaml" },
			extra_filetypes = { "astro" },
		}),
	},
})

require("mason").setup()
require("mason-lspconfig").setup()
local lsp = require("lsp-zero")

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

lsp.configure("jdtls", {
	settings = {
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
		java = {
			import = {
				gradle = {
					enabled = false,
				},
			},
			jdt = {
				ls = {
					androidSupport = {
						enabled = false,
					},
				},
			},
		},
	},
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
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
				ignoreDir = { ".git", "plugged" },
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

local mason_registry = require("mason-registry")
local vue_lsp_path = mason_registry.get_package("vue-language-server"):get_install_path()
	.. "/node_modules/@vue/language-server"

lsp.configure("ts_ls", {
	-- root_dir = nvim_lsp.util.root_pattern("package.json"),
	-- init_options for vue
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vue_lsp_path,
				languages = { "vue" },
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	settings = {
		typescript = js_inlay_hints,
		javascript = js_inlay_hints,
	},
})

lsp.configure("volar", {})

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
	map("gr", Snacks.picker.lsp_references)
	map("gd", Snacks.picker.lsp_definitions)
	map("<leader>ds", Snacks.picker.lsp_symbols)
	map("<leader>ws", Snacks.picker.lsp_workspace_symbols)
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
		null_ls.builtins.diagnostics.eslint.with({
			only_local = "node_modules/.bin",
		}),
		null_ls.builtins.code_actions.eslint.with({
			only_local = "node_modules/.bin",
			env = {
				ESLINT_USE_FLAT_CONFIG = false,
			},
		}),
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier.with({
			only_local = "node_modules/.bin",
			disabled_filetypes = { "html", "yml", "yaml" },
			extra_filetypes = { "astro" },
		}),
	},
})

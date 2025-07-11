local lsp = require("lsp-zero")
local nvim_lsp = require("lspconfig")

require("nvim-autopairs").setup({
	fast_wrap = {},
})

vim.diagnostic.config({
	jump = {
		float = true,
	},
})

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

lsp.configure("intelephense", {
	init_options = {
		globalStoragePath = os.getenv("HOME") .. "/.local/share/intelephense",
	},
})

lsp.configure("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				ignoreDir = { ".git", "plugged" },
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

lsp.configure("gopls", {
	settings = {
		gopls = {
			usePlaceholders = true,
			gofumpt = true, -- probably doesnt work
			analyses = {
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			codelenses = {
				gc_details = false,
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

lsp.ensure_installed({
	"ts_ls",
})
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
		javascipt = js_inlay_hints,
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

	map("]g", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end)
	map("[g", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end)
	map("<leader>ca", vim.lsp.buf.code_action)
	map("<leader>vr", vim.lsp.buf.references)
	map("gR", vim.lsp.buf.rename)
	map("<leader>i", toggle_inlay_hints)
	map("gr", Snacks.picker.lsp_references)
	map("gd", Snacks.picker.lsp_definitions)
	map("<leader>ds", Snacks.picker.lsp_symbols)
	map("<leader>ws", Snacks.picker.lsp_workspace_symbols)
end)

lsp.setup()

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
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.diagnostics.mypy.with({
			extra_args = { "--python-executable", "./env/bin/python" },
		}),
		null_ls.builtins.formatting.black.with({
			only_local = "env/bin",
		}),
		null_ls.builtins.diagnostics.phpstan.with({
			prefer_local = "vendor/bin",
			method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
			to_temp_file = false,
			timeout = 20000,
			diagnostic_config = {
				virtual_text = false,
				underline = true,
				signs = true,
				update_in_insert = false,
				severity_sort = false,
			},
		}),
		null_ls.builtins.formatting.phpcsfixer,
		null_ls.builtins.formatting.prettier.with({
			condition = function(utils)
				return utils.root_has_file({ ".prettierrc.json", ".prettierrc" })
			end,
			prefer_local = "node_modules/.bin",
			extra_filetypes = { "astro", "svelte", "vue" },
		}),
		null_ls.builtins.formatting.stylua,
	},
})

vim.cmd([[command! -range=% Pfmt <line1>,<line2>!npx prettier --stdin-filepath %]])

require("mason").setup()

require("nvim-autopairs").setup({
	fast_wrap = {},
})

vim.diagnostic.config({
	jump = {
		float = true,
	},
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
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
vim.lsp.enable("lua_ls")

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			directoryFilters = { "-**/.git", "-**/node_modules" },
			semanticTokens = true,
		},
	},
})
vim.lsp.enable("gopls")

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
vim.lsp.config("ts_ls", {
	settings = {
		typescript = js_inlay_hints,
		javascipt = js_inlay_hints,
	},
})
vim.lsp.enable("ts_ls")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("astro")
vim.lsp.enable("eslint")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("dockerls")

local toggle_inlay_hints = function()
	local enabled = vim.lsp.inlay_hint.is_enabled({ nil })
	local state = "Enabled"
	if enabled then
		state = "Disabled"
	end
	vim.lsp.inlay_hint.enable(not enabled)
	print(string.format("%s inlay hints", state))
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local bufnr = ev.buf

		-- completions only if we have LSP
		vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

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
	end,
})

local null_ls = require("null-ls")
local format = require("lsp-format")
null_ls.setup({
	on_attach = format.on_attach,
	-- Vue setup:
	-- prettierd - only local
	-- NextJs setup:
	-- prettierd - default
	sources = {
		null_ls.builtins.completion.spell,
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

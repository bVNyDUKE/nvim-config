require("mason").setup()

vim.diagnostic.config({
	jump = {
		on_jump = function()
			vim.diagnostic.open_float()
		end,
	},
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if path ~= vim.fn.stdpath("config") then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				ignoreDir = { ".git", "autoload" },
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			directoryFilters = { "-**/.git", "-**/node_modules" },
			semanticTokens = true,
			gofumpt = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				constantValues = true,
				functionTypeParameters = true,
				ignoredError = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})

local js_inlay_hints = {
	inlayHints = {
		enumMemberValues = {
			enabled = "all",
		},
		functionLikeReturnTypes = {
			enabled = "all",
		},
		parameterNames = {
			enabled = "all",
		},
		propertyDeclarationTypes = {
			enabled = true,
		},
		variableTypes = {
			enabled = true,
		},
	},
}
vim.lsp.config("vtsls", {
	settings = {
		typescript = js_inlay_hints,
		javascript = js_inlay_hints,
		vtsls = {
			autoUseWorkspaceTsdk = true,
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.stdpath("data")
							.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
						languages = { "vue" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

vim.lsp.config("tailwindcss", { root_markers = { "tailwind.config.js" } })
vim.lsp.enable({
	"oxlint",
	"eslint",
	"lua_ls",
	"vtsls",
	"gopls",
	"vue_ls",
})

local toggle_inlay_hints = function()
	local enabled = vim.lsp.inlay_hint.is_enabled()
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
			vim.keymap.set("n", keys, func, { buffer = bufnr, remap = false, nowait = true })
		end

		map("]g", function()
			vim.diagnostic.jump({ count = 1 })
		end)
		map("[g", function()
			vim.diagnostic.jump({ count = -1 })
		end)
		map("<leader>ca", vim.lsp.buf.code_action)
		map("<leader>vr", vim.lsp.buf.references)
		map("gR", vim.lsp.buf.rename)
		map("<leader>i", toggle_inlay_hints)
		map("gr", function()
			Snacks.picker.lsp_references()
		end)
		map("gd", function()
			Snacks.picker.lsp_definitions()
		end)
		map("gi", function()
			Snacks.picker.lsp_implementations()
		end)
		map("<leader>ds", function()
			Snacks.picker.lsp_symbols()
		end)
		map("<leader>ws", function()
			Snacks.picker.lsp_workspace_symbols()
		end)
	end,
})

vim.api.nvim_create_user_command("LspCheck", function()
	vim.cmd.checkhealth("lsp")
end, { desc = "Check status of LSP servers" })

vim.api.nvim_create_user_command("LspLog", function()
	vim.api.nvim_cmd({
		cmd = "tabedit",
		args = { vim.lsp.log.get_filename() },
		magic = { file = false, bar = false },
	}, {})
end, { desc = "Open the LSP log file" })

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
				ignoreDir = { ".git", "plugged", "autoload" },
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
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.stdpath("data")
							.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
						languages = { "vue" },
						configNamespace = "typescript",
					},
				},
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

vim.lsp.config("cssls", {
	settings = {
		css = {
			validate = false,
		},
	},
})

vim.lsp.config("tailwindcss", { root_markers = { "tailwind.config.js" } })
vim.lsp.enable({
	"oxlint",
	"eslint",
	"lua_ls",
	"vtsls",
	"gopls",
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
		map("gi", Snacks.picker.lsp_implementations)
		map("<leader>ds", Snacks.picker.lsp_symbols)
		map("<leader>ws", Snacks.picker.lsp_workspace_symbols)
	end,
})

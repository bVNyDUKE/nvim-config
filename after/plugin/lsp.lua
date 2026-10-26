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
local tsls_config = {
	settings = {
		["js/ts"] = js_inlay_hints,
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}

vim.lsp.config("cssls", {
	settings = {
		css = {
			validate = false,
		},
	},
})

-- vim.lsp.config("vtsls", tsls_config)
vim.lsp.config("tsc", tsls_config)
vim.lsp.config("tailwindcss", { root_markers = { "tailwind.config.js" } })
vim.lsp.enable({
	"oxlint",
	"eslint",
	"lua_ls",
	"tsc",
	-- "vtsls"
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

local patched_clients = {}
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local bufnr = ev.buf

		-- completions only if we have LSP
		vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

		local map = function(keys, func)
			vim.keymap.set("n", keys, func, { buffer = bufnr, remap = false })
		end

		-- Workaround: tsgo sends a `[Symbol]` completion whose textEdit replaces
		-- the `.`, which drags the client's start column back and filters out
		-- every other item. Drop items whose edit starts before the cursor.
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.name == "tsc" and not patched_clients[client.id] then
			patched_clients[client.id] = true

			local request = client.request
			client.request = function(self, method, params, handler, ...)
				if method == "textDocument/completion" and handler then
					local orig = handler
					handler = function(err, result, ...)
						if result then
							local list = result.items and result or { items = result }
							local pos = params.position
							list.items = vim.tbl_filter(function(item)
								local te = item.textEdit
								local r = te and (te.range or te.insert)
								return not (r and r.start.line == pos.line and r.start.character < pos.character)
							end, list.items)
							result = result.items and list or list.items
						end
						return orig(err, result, ...)
					end
				end
				return request(self, method, params, handler, ...)
			end
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

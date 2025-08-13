require("mason").setup()

vim.diagnostic.config({
	jump = {
		float = true,
	},
})

vim.lsp.config("jdtls", {
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
				ignoreDir = { ".git", "plugged" },
				checkThirdParty = false,
				library = vim.tbl_filter(function(d)
					return not d:match(vim.fn.stdpath("config") .. "/?a?f?t?e?r")
				end, vim.api.nvim_get_runtime_file("", true)),
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

-- Formatting
local format_augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local format_callback = function(client_name)
	return function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = format_augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = format_augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = bufnr,
						async = false,
						filter = function(c)
							return c.name == client_name
						end,
					})
				end,
			})
		end
	end
end

vim.lsp.config("gopls", {
	on_attach = format_callback("gopls"),
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

-- Vue Settings
local vue_language_server_path = vim.fn.stdpath("data")
	.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
}

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
local vtsls_config = {
	settings = {
		typescript = js_inlay_hints,
		javascript = js_inlay_hints,
		vtsls = {
			tsserver = {
				globalPlugins = {
					vue_plugin,
				},
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}

local vue_ls_config = {
	on_init = function(client)
		client.handlers["tsserver/request"] = function(_, result, context)
			local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
			if #clients == 0 then
				vim.notify(
					"Could not find `vtsls` lsp client, `vue_ls` would not work without it.",
					vim.log.levels.ERROR
				)
				return
			end
			local ts_client = clients[1]

			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
				command = "typescript.tsserverRequest",
				arguments = {
					command,
					payload,
				},
			}, { bufnr = context.bufnr }, function(_, r)
				local response_data = { { id, r.body } }
				client:notify("tsserver/response", response_data)
			end)
		end
	end,
}

vim.lsp.config("vtsls", vtsls_config)
vim.lsp.config("vue_ls", vue_ls_config)
vim.lsp.enable({
	"lua_ls",
	"gopls",
	"vtsls",
	"vue_ls",
	"html",
	"cssls",
	"astro",
	"eslint",
	"tailwindcss",
	"dockerls",
	"jdtls",
	"pyright",
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

local null_ls = require("null-ls")
null_ls.setup({
	on_attach = format_callback("null-ls"),
	-- Vue setup:
	-- prettierd - only local
	-- NextJs setup:
	-- prettierd - default
	sources = {
		-- null_ls.builtins.diagnostics.mypy.with({
		-- 	extra_args = { "--python-executable", "./env/bin/python" },
		-- }),
		null_ls.builtins.completion.spell, --for json
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
			extra_filetypes = { "astro", "vue" },
		}),
		null_ls.builtins.formatting.stylua,
	},
})

vim.cmd([[command! -range=% Pfmt <line1>,<line2>!npx prettier --stdin-filepath %]])

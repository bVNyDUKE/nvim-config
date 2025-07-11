vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.textwidth = 79
vim.opt_local.autoindent = true
vim.opt_local.expandtab = true
vim.opt_local.smarttab = true

local lspName = "lua_ls"
-- lsp servers are installed here by mason
local lspPath = vim.fs.normalize(table.concat({ vim.fn.stdpath("data"), "mason", "bin", "lua-language-server" }, "/"))
vim.lsp.config(lspName, {
	cmd = { lspPath },
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

vim.lsp.enable(lspName)

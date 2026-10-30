vim.api.nvim_create_user_command("TSInstallMine", function()
	require("nvim-treesitter").install({
		"typescript",
		"tsx",
		"javascript",
		"vue",
		"go",
		"gomod",
		"lua",
		"json",
		"yaml",
		"html",
		"css",
		"markdown",
		"markdown_inline",
	})
end, {})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		-- returns false/errors if there is no parser for this filetype
		if not pcall(vim.treesitter.start, args.buf) then
			return
		end
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

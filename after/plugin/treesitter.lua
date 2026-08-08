local treesitter = require("nvim-treesitter")

vim.treesitter.language.register("tsx", "typescriptreact")
vim.treesitter.language.register("typescript", "typescript")

treesitter.setup()

local parsers = {
	"lua",
	"javascript",
	"tsx",
	"json",
	"python",
	"markdown",
	"rust",
	"go",
	"vim",
	"vimdoc",
	"yaml",
	"toml",
	"typescript",
	"vue",
	"css",
	"html",
	"jsdoc",
}

local supported_filetypes = vim.list_extend(vim.deepcopy(parsers), { "javascriptreact", "typescriptreact" })

local function start(buf)
	if vim.api.nvim_buf_is_valid(buf) and vim.tbl_contains(supported_filetypes, vim.bo[buf].filetype) then
		vim.treesitter.start()
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = supported_filetypes,
	callback = function(args)
		start(args.buf)
	end,
})

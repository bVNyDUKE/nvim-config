local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		layout_strategy = "vertical",
		preview_cutoff = 20,
		file_ignore_patterns = {
			"node_modules",
			"vendor",
		},
		mappings = {
			n = {
				["q"] = actions.close,
				["<c-d>"] = actions.delete_buffer,
			},
		},
	},
	pickers = {
		lsp_references = {
			fname_width = 60,
			include_current_line = true,
			include_declaration = false,
			jump_type = "tab",
		},
	},
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>p", builtin.fd, { desc = "[F]ind files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind [W]ord" })
vim.keymap.set("n", "<leader>fs", builtin.git_status, { desc = "[F]ind Git [S]tatus" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fb", builtin.git_branches, { desc = "[F]ind Git [B]ranches" })
vim.keymap.set("n", "<leader>ff", builtin.buffers, { desc = "[F]ind Bu[f]fers" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume previous search" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })

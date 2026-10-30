local Snacks = require("snacks")
Snacks.setup(
	-- @type snacks.Config
	{
		picker = {
			enabled = true,
			layout = {
				preset = "vertical",
				layout = {
					width = 0.7,
				},
			},
			matcher = {
				fuzzy = false,
			},
			sources = {
				buffers = {
					supports_live = false,
				},
				files = {
					hidden = true,
					include = { ".gitignore", ".env", ".env.local", ".skaffold.env" },
					matcher = {
						fuzzy = false,
					},
				},
				git_branches = {
					matcher = {
						fuzzy = false,
					},
				},
				explorer = {
					hidden = true,
					ignored = true,
					exclude = {},
					layout = {
						preset = "sidebar",
						layout = {
							position = "right",
							width = 0.3,
						},
					},
				},
			},
		},
	}
)
-- stylua: ignore start
vim.keymap.set("n", "<leader>p", function() Snacks.picker.files() end, { desc = "[F]ind files" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "[F]ind [G]rep" })
vim.keymap.set("n", "<leader>fw", function() Snacks.picker.grep_word() end, { desc = "[F]ind [W]ord" })
vim.keymap.set("n", "<leader>fs", function() Snacks.picker.git_status() end, { desc = "[F]ind Git [S]tatus" })
vim.keymap.set("n", "<leader>fd", function() Snacks.picker.diagnostics() end, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.git_branches() end, { desc = "[F]ind Git [B]ranches" })
vim.keymap.set("n", "<leader>fl", function() Snacks.picker.git_log() end, { desc = "[F]ind Git [L]og" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.buffers() end, { desc = "[F]ind Bu[f]fers" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.resume() end, { desc = "[F]ind [R]esume previous search" })
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "[F]ind [K]maps" })
vim.keymap.set("n", "<leader>e", function() Snacks.picker.explorer() end, { desc = "[F]ind [E]xplore" })
-- stylua: ignore end

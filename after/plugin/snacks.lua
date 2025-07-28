require("snacks")
Snacks.setup(
	-- @type snacks.Config
	{
		picker = {
			enabled = true,
			matcher = {
				fuzzy = false,
			},
			layout = {
				cycle = true,
			},
			sources = {
				explorer = {
					layout = {
						preset = "sidebar",
						preview = false,
						layout = {
							position = "right",
						},
					},
				},
			},
		},
	}
)
vim.keymap.set("n", "<leader>p", Snacks.picker.files, { desc = "[F]ind files" })
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep, { desc = "[F]ind [G]rep" })
vim.keymap.set("n", "<leader>fw", Snacks.picker.grep_word, { desc = "[F]ind [W]ord" })
vim.keymap.set("n", "<leader>fs", Snacks.picker.git_status, { desc = "[F]ind Git [S]tatus" })
vim.keymap.set("n", "<leader>fd", Snacks.picker.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fb", Snacks.picker.git_branches, { desc = "[F]ind Git [B]ranches" })
vim.keymap.set("n", "<leader>ff", Snacks.picker.buffers, { desc = "[F]ind Bu[f]fers" })
vim.keymap.set("n", "<leader>fr", Snacks.picker.resume, { desc = "[F]ind [R]esume previous search" })
vim.keymap.set("n", "<leader>fh", Snacks.picker.help, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>e", Snacks.picker.explorer, { desc = "[F]ind [E]xplore" })

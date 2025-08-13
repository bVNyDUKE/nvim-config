local gs = require("gitsigns")

gs.setup({
	sign_priority = 3,
	on_attach = function(bufnr)
		local function map(mode, lhs, rhs, opts)
			opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
			vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
		end

		map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
		map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

		map("n", "ghs", ":Gitsigns stage_hunk<CR>")
		map("v", "ghs", ":Gitsigns stage_hunk<CR>")
		map("n", "ghu", ":Gitsigns reset_hunk<CR>")
		map("v", "ghu", ":Gitsigns reset_hunk<CR>")
		map("n", "ghS", "<cmd>Gitsigns stage_buffer<CR>")
		map("n", "ghU", "<cmd>Gitsigns undo_stage_hunk<CR>")
		map("n", "ghR", "<cmd>Gitsigns reset_buffer<CR>")
		map("n", "ghp", "<cmd>Gitsigns preview_hunk<CR>")
		map("n", "gbb", ":Gitsigns blame<CR>")
		vim.keymap.set("n", "ghb", function()
			gs.blame_line({ full = true })
		end)
		map("n", "gtb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
		map("n", "ghd", "<cmd>Gitsigns diffthis<CR>")
		map("n", "ghD", '<cmd>lua require"gitsigns".diffthis("~")<CR>')
		map("n", "gtd", "<cmd>Gitsigns toggle_deleted<CR>")

		map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
		map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})

-- local neogit = require("neogit")
-- neogit.setup({})

vim.keymap.set("n", "<leader>ng", ":G <CR>")

require("gitsigns").setup({
	sign_priority = 3,
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	on_attach = function(bufnr)
		local function map(mode, lhs, rhs, opts)
			opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
			vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
		end

		map("n", "]c", "&diff ? ']c' : ':Gitsigns next_hunk<CR>'", { expr = true })
		map("n", "[c", "&diff ? '[c' : ':Gitsigns prev_hunk<CR>'", { expr = true })

		map("n", "ghs", ":Gitsigns stage_hunk<CR>")
		map("v", "ghs", ":Gitsigns stage_hunk<CR>")
		map("n", "ghu", ":Gitsigns reset_hunk<CR>")
		map("v", "ghu", ":Gitsigns reset_hunk<CR>")
		map("n", "ghS", ":Gitsigns stage_buffer<CR>")
		map("n", "ghU", ":Gitsigns undo_stage_hunk<CR>")
		map("n", "ghR", ":Gitsigns reset_buffer<CR>")
		map("n", "ghp", ":Gitsigns preview_hunk<CR>")
		map("n", "ghb", ':lua require"gitsigns".blame_line{full=true}<CR>')
		map("n", "gtb", ":Gitsigns toggle_current_line_blame<CR>")
		map("n", "ghd", ":Gitsigns diffthis<CR>")
		map("n", "ghD", ':lua require"gitsigns".diffthis("~")<CR>')
		map("n", "gtd", ":Gitsigns toggle_deleted<CR>")

		map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
		map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})

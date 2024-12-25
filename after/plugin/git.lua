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
		local gs = require("gitsigns")
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gs.nav_hunk("next")
			end
		end)
		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gs.nav_hunk("prev")
			end
		end)

		map("n", "ghs", gs.stage_hunk)
		map("n", "ghr", gs.reset_hunk)
		map("v", "ghs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("v", "ghr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("n", "ghu", gs.undo_stage_hunk)
		map("n", "ghS", gs.stage_buffer)
		map("n", "ghR", gs.reset_buffer)
		map("n", "ghp", gs.preview_hunk)
		map("n", "ghb", function()
			gs.blame_line({ full = true })
		end)
		map("n", "gtb", gs.toggle_current_line_blame)
		map("n", "ghd", gs.diffthis)
		map("n", "ghD", function()
			gs.diffthis("~")
		end)
		map("n", "gtd", gs.toggle_deleted)

		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})

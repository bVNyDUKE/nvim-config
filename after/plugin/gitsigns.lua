local gs = require("gitsigns")
gs.setup({
	sign_priority = 3,
	on_attach = function(bufnr)
		local function map(mode, lhs, rhs, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				---@diagnostic disable-next-line
				gs.nav_hunk("next", { wrap = true })
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				---@diagnostic disable-next-line
				gs.nav_hunk("prev")
			end
		end)

		map("n", "ghs", gs.stage_hunk)
		map("n", "ghu", gs.reset_hunk)

		map("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("n", "ghS", gs.stage_buffer)
		map("n", "ghR", gs.reset_buffer)

		map("n", "ghp", gs.preview_hunk)
		map("n", "gbb", gs.blame)
		map("n", "ghb", function()
			gs.blame_line({ full = true })
		end)
		map("n", "gtb", gs.toggle_current_line_blame)
		map("n", "ghd", gs.diffthis)
		map("n", "ghD", function()
			---@diagnostic disable-next-line
			gs.diffthis("~")
		end)
		map({ "o", "x" }, "ih", gs.select_hunk)
	end,
})

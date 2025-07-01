vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-termopen", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

local function open_small_term()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 20)
end

vim.keymap.set("n", "<leader>st", open_small_term)

vim.keymap.set("t", "jj", "<C-\\><C-N>")

vim.api.nvim_create_user_command("Kl", function(opts)
	open_small_term()
	-- depends on my custom kl alias for kubectl logs
	vim.fn.chansend(vim.bo.channel, { "kl " .. opts.args .. "\r\n" })
	local buf = vim.api.nvim_get_current_buf()

	vim.keymap.set("n", "q", function()
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("silent! stopinsert")
			vim.fn.chansend(vim.bo.channel, "\x03")
		end)
		vim.api.nvim_buf_delete(buf, { force = true })
	end, { buffer = buf, desc = "Kill the logging buffer" })
end, {
	nargs = 1,
	complete = function(arg)
		local services = { "acm", "analysis-model", "audit", "scheduler" }
		local res = {}
		for _, value in pairs(services) do
			if string.sub(value, 1, #arg) == arg then
				table.insert(res, value)
			end
		end
		return res
	end,
})

local M = {}

function M.apply_all_tailwind_actions_buffer()
	local bufnr = vim.api.nvim_get_current_buf()

	local all_diagnostics = vim.diagnostic.get(bufnr)

	if #all_diagnostics == 0 then
		vim.notify("No diagnostics found in buffer", vim.log.levels.INFO)
		return
	end

	-- Filter for suggestCanonicalClasses diagnostics
	-- Message format: "The class `X` can be written as `Y`"
	local edits = {}
	for _, diag in ipairs(all_diagnostics) do
		if diag.code == "suggestCanonicalClasses" or (diag.message and diag.message:match("can be written as")) then
			local old_class, new_class = diag.message:match("The class `([^`]+)` can be written as `([^`]+)`")
			if old_class and new_class then
				table.insert(edits, {
					lnum = diag.lnum,
					col = diag.col,
					end_lnum = diag.end_lnum or diag.lnum,
					end_col = diag.end_col or (diag.col + #old_class),
					old_class = old_class,
					new_class = new_class,
				})
			end
		end
	end

	if #edits == 0 then
		vim.notify("No canonical class fixes found", vim.log.levels.INFO)
		return
	end

	-- Sort in reverse order so edits don't shift positions
	table.sort(edits, function(a, b)
		if a.lnum ~= b.lnum then
			return a.lnum > b.lnum
		end
		return a.col > b.col
	end)

	vim.notify(string.format("Applying %d Tailwind CSS fixes...", #edits), vim.log.levels.INFO)

	for _, edit in ipairs(edits) do
		vim.api.nvim_buf_set_text(bufnr, edit.lnum, edit.col, edit.end_lnum, edit.end_col, { edit.new_class })
	end
end

return M

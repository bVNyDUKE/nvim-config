local cmp = {} -- statusline components

--- highlight pattern
-- This has three parts:
-- 1. the highlight group
-- 2. text content
-- 3. special sequence to restore highlight: %*
-- Example pattern: %#SomeHighlight#some-text%*
local hi_pattern = "%%#%s#%s%%*"

local function orange(text)
	return hi_pattern:format("DiagnosticWarn", text)
end

local function red(text)
	return hi_pattern:format("DiagnosticWarn", text)
end

local function green(text)
	return hi_pattern:format("DiagnosticOk", text)
end

local function hint(text)
	return hi_pattern:format("DiagnosticHint", text)
end

function _G._statusline_component(name)
	return cmp[name]()
end

function cmp.git_status()
	local git_info = vim.b.gitsigns_status_dict
	if not git_info or git_info.head == "" then
		return ""
	end

	local head = git_info.head
	local added = git_info.added and (" +" .. git_info.added) or ""
	local changed = git_info.changed and (" ~" .. git_info.changed) or ""
	local removed = git_info.removed and (" -" .. git_info.removed) or ""
	if git_info.added == 0 then
		added = ""
	end
	if git_info.changed == 0 then
		changed = ""
	end
	if git_info.removed == 0 then
		removed = ""
	end

	return table.concat({
		"[ ", -- branch icon
		head,
		added,
		changed,
		removed,
		"]",
	})
end

function cmp.diagnostic_status()
	local ok = "[OK]"

	local ignore = {
		["c"] = true, -- command mode
		["t"] = true, -- terminal mode
	}

	local mode = vim.api.nvim_get_mode().mode

	if ignore[mode] then
		return ok
	end

	--- @param levels {color: function, symbol: string, level: vim.diagnostic.Severity}[]
	--- @return string[]
	local getLevels = function(levels)
		local res = {}
		for _, value in ipairs(levels) do
			local count = #vim.diagnostic.get(0, { severity = value.level })
			if count > 0 then
				table.insert(res, value.color(table.concat({ " ", value.symbol, ":", count, " " })))
			end
		end
		return res
	end

	local levels = vim.diagnostic.severity
	local level_counts = getLevels({
		{ level = levels.ERROR, color = red, symbol = "E" },
		{ level = levels.WARN, color = orange, symbol = "W" },
		{ level = levels.INFO, color = green, symbol = "I" },
		{ level = levels.HINT, color = hint, symbol = "H" },
	})
	if #level_counts == 0 then
		return ok
	end

	return table.concat({ "[", table.concat(level_counts), "]" })
end

local statusline = {
	'%{%v:lua._statusline_component("diagnostic_status")%} ',
	'%{%v:lua._statusline_component("git_status")%} ',
	"%f ",
	"%r",
	"%m",
	"%=",
	"%L ",
	"%{&filetype} ",
}

vim.o.statusline = table.concat(statusline, "")

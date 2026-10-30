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
	return hi_pattern:format("DiagnosticError", text)
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

	return table.concat({
		"[ ",
		"%{b:gitsigns_head} ",
		"%{b:gitsigns_status}",
		"]",
	})
end

--- path relative to the project root (nearest .git), falling back to cwd
function cmp.filepath()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		return "[No Name]"
	end

	-- cache the root per buffer, false means no root was found
	if vim.b.statusline_root == nil then
		vim.b.statusline_root = vim.fs.root(0, ".git") or false
	end

	local root = vim.b.statusline_root
	local rel = root and vim.fs.relpath(root, name)
	return rel or vim.fn.fnamemodify(name, ":~:.")
end

function cmp.filetype_icon()
	local ft = vim.bo.filetype
	if ft == "" then
		return ""
	end

	local icon = require("mini.icons").get("filetype", ft)
	return icon
end

--- @param levels {color: function, symbol: string, level: vim.diagnostic.Severity}[]
--- @return string[]
local getLevels = function(levels)
	local counts = vim.diagnostic.count(0)
	local res = {}
	for _, value in ipairs(levels) do
		local count = counts[value.level] or 0
		if count > 0 then
			table.insert(res, value.color(table.concat({ " ", value.symbol, ":", count, " " })))
		end
	end
	return res
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
	'%{%v:lua._statusline_component("git_status")%} ',
	-- %{} instead of %{%%} so % in filenames isn't parsed as a statusline item
	'%{v:lua._statusline_component("filepath")} ',
	"%r",
	"%m",
	"%=",
	'%{%v:lua._statusline_component("diagnostic_status")%} ',
	"%L ",
	'%{v:lua._statusline_component("filetype_icon")} ',
}

--- Redraw statusline on WinEnter BufEnter events
vim.api.nvim_exec2(
	[[
    augroup Statusline
    au!
    au DiagnosticChanged * redrawstatus
    augroup END
]],
	{}
)

vim.o.statusline = table.concat(statusline, "")

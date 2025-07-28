local cmp = {} -- statusline components

--- highlight pattern
-- This has three parts:
-- 1. the highlight group
-- 2. text content
-- 3. special sequence to restore highlight: %*
-- Example pattern: %#SomeHighlight#some-text%*
local hi_pattern = "%%#%s#%s%%*"

function _G._statusline_component(name)
	return cmp[name]()
end

local modes = {
	["n"] = "NORMAL",
	["nt"] = "TERM-NORM",
	["V"] = "VISUAL",
	["v"] = "VISUAL",
	["i"] = "INSERT",
	["c"] = "COMMAND",
	["t"] = "TERMINAL",
}

function cmp.mode_name()
	local mode = vim.api.nvim_get_mode().mode
	local mode_name = modes[mode]
	return hi_pattern:format("Search", " " .. (mode_name and mode_name or mode) .. " ")
end

function cmp.diagnostic_status()
	local ok = " OK "

	local ignore = {
		["c"] = true, -- command mode
		["t"] = true, -- terminal mode
	}

	local mode = vim.api.nvim_get_mode().mode

	if ignore[mode] then
		return ok
	end

	local levels = vim.diagnostic.severity
	local errors = #vim.diagnostic.get(0, { severity = levels.ERROR })
	local warnings = #vim.diagnostic.get(0, { severity = levels.WARN })
	local show_diagnostics = errors > 0 or warnings > 0

	if not show_diagnostics then
		return ok
	end

	local error_count = ""
	local warn_count = ""

	if errors > 0 then
		error_count = hi_pattern:format("DiagnosticSignError", " E:" .. errors .. " ")
	end

	if warnings > 0 then
		warn_count = hi_pattern:format("DiagnosticSignWarn", " W:" .. warnings .. " ")
	end

	return error_count .. warn_count
end

local statusline = {
	'%{%v:lua._statusline_component("mode_name")%} ',
	"%{FugitiveStatusline()} ",
	'%{%v:lua._statusline_component("diagnostic_status")%} ',
	"%t ",
	"%r",
	"%m",
	"%=",
	"%{&filetype} ",
}

vim.o.statusline = table.concat(statusline, "")
vim.opt.showmode = false

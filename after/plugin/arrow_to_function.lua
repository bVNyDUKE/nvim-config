-- plugin/arrow_to_function.lua
-- Toggle between
--   const foo = (a: T): R => ...
-- and
--   function foo(a: T): R { ... }
-- using treesitter. Works in typescript, typescriptreact, javascript, javascriptreact.

local function text(node, buf)
	return vim.treesitter.get_node_text(node, buf)
end

local function warn(msg)
	vim.notify(msg, vim.log.levels.WARN)
end

local function indent_of(buf, row)
	return vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]:match("^%s*")
end

local function indent_unit(buf)
	return vim.bo[buf].expandtab and string.rep(" ", vim.fn.shiftwidth()) or "\t"
end

local function has_child(node, type)
	for child in node:iter_children() do
		if child:type() == type then
			return true
		end
	end
	return false
end

-- Nodes that introduce their own `this` / `arguments`. Arrow functions are not
-- in the list, because they inherit both from the enclosing scope.
local own_this = {
	["function"] = true,
	function_expression = true,
	function_declaration = true,
	generator_function = true,
	generator_function_declaration = true,
	method_definition = true,
	class = true,
	class_declaration = true,
	class_body = true,
}

local function uses_this_or_arguments(node, buf)
	for child in node:iter_children() do
		local t = child:type()
		if t == "this" or (t == "identifier" and text(child, buf) == "arguments") then
			return true
		end
		if not own_this[t] and uses_this_or_arguments(child, buf) then
			return true
		end
	end
	return false
end

-- Walk up from the cursor and return whichever convertible construct is closest.
local function find_target()
	local node = vim.treesitter.get_node()
	while node do
		local t = node:type()
		if t == "variable_declarator" then
			local value = node:field("value")[1]
			if value and value:type() == "arrow_function" then
				return "arrow", node, value
			end
		elseif t == "function_declaration" then
			return "function", node
		elseif t == "generator_function_declaration" then
			return "generator", node
		end
		node = node:parent()
	end
end

---------------------------------------------------------------------------
-- arrow -> function
---------------------------------------------------------------------------

local function arrow_to_function(buf, declarator, arrow)
	if declarator:field("type")[1] then
		-- `const f: Handler = (e) => ...` relies on contextual typing; converting
		-- would silently drop the parameter types.
		return warn("Variable has a type annotation; convert manually")
	end

	local decl = declarator:parent() -- lexical_declaration or variable_declaration
	if decl:named_child_count() ~= 1 then
		return warn("Multiple declarators in one statement; split them first")
	end

	local name = text(declarator:field("name")[1], buf)
	local tparams = arrow:field("type_parameters")[1]
	local params = arrow:field("parameters")[1]
	local single = arrow:field("parameter")[1] -- `x => ...` without parens
	local rtype = arrow:field("return_type")[1]
	local body = arrow:field("body")[1]

	local sr, sc, er, ec = decl:range()
	local indent = indent_of(buf, sr)

	local body_text
	if body:type() == "statement_block" then
		body_text = text(body, buf)
	else
		local unit = indent_unit(buf)
		local expr = body
		-- `() => ({ a: 1 })`: the parens are only needed in arrow position
		if expr:type() == "parenthesized_expression" and expr:named_child(0):type() == "object" then
			expr = expr:named_child(0)
		end
		local expr_text = (text(expr, buf):gsub("\n", "\n" .. unit))
		body_text = "{\n" .. indent .. unit .. "return " .. expr_text .. ";\n" .. indent .. "}"
	end

	local header = (has_child(arrow, "async") and "async " or "")
		.. "function "
		.. name
		.. (tparams and text(tparams, buf) or "")
		.. (params and text(params, buf) or "(" .. text(single, buf) .. ")")
		.. (rtype and text(rtype, buf) or "")
		.. " "

	-- Replaces only the declaration, so a leading `export` stays in place.
	-- The trailing `;` of the declaration is dropped.
	vim.api.nvim_buf_set_text(buf, sr, sc, er, ec, vim.split(header .. body_text, "\n"))
end

---------------------------------------------------------------------------
-- function -> arrow
---------------------------------------------------------------------------

local function function_to_arrow(buf, fn)
	local parent = fn:parent()
	if parent and parent:type() == "export_statement" and has_child(parent, "default") then
		return warn("`export default function` has no arrow equivalent in place; convert manually")
	end

	local name = text(fn:field("name")[1], buf)

	-- Overload signatures (`function f(a: string): void;`) can't be attached to a const.
	local prev = fn:prev_named_sibling()
	if prev and prev:type() == "function_signature" and text(prev:field("name")[1], buf) == name then
		return warn("Function has overload signatures; convert manually")
	end

	local body = fn:field("body")[1]
	if uses_this_or_arguments(body, buf) then
		return warn("Body uses `this` or `arguments`, which arrows don't bind; convert manually")
	end

	local tparams = fn:field("type_parameters")[1]
	local params = fn:field("parameters")[1]
	local rtype = fn:field("return_type")[1]

	local tparams_text = tparams and text(tparams, buf) or ""
	-- In .tsx, `<T>(x) => ...` parses as JSX; it needs to be `<T,>`.
	if
		tparams
		and vim.bo[buf].filetype == "typescriptreact"
		and tparams:named_child_count() == 1
		and not tparams_text:find("extends")
		and not tparams_text:find(",%s*>$")
	then
		tparams_text = tparams_text:gsub(">$", ",>")
	end

	-- `{ return expr; }` collapses to an expression body.
	local body_text
	local only = body:named_child_count() == 1 and body:named_child(0) or nil
	local ret_expr = only and only:type() == "return_statement" and only:named_child(0) or nil
	if ret_expr then
		local unit = indent_unit(buf)
		local expr_text = text(ret_expr, buf):gsub("\n" .. unit, "\n")
		if ret_expr:type() == "object" then
			expr_text = "(" .. expr_text .. ")"
		end
		body_text = expr_text
	else
		body_text = text(body, buf)
	end

	local line = "const "
		.. name
		.. " = "
		.. (has_child(fn, "async") and "async " or "")
		.. tparams_text
		.. text(params, buf)
		.. (rtype and text(rtype, buf) or "")
		.. " => "
		.. body_text
		.. ";"

	local sr, sc, er, ec = fn:range()
	vim.api.nvim_buf_set_text(buf, sr, sc, er, ec, vim.split(line, "\n"))
end

---------------------------------------------------------------------------
-- add / remove arrow body braces
---------------------------------------------------------------------------

local function toggle_arrow_braces()
	local buf = vim.api.nvim_get_current_buf()

	local arrow = vim.treesitter.get_node()
	while arrow and arrow:type() ~= "arrow_function" do
		arrow = arrow:parent()
	end
	if not arrow then
		return warn("No arrow function under cursor")
	end

	local body = arrow:field("body")[1]
	local unit = indent_unit(buf)
	local sr, sc, er, ec = body:range()
	local new_text

	if body:type() == "statement_block" then
		-- Remove braces: only valid for a block that is exactly `{ return expr; }`.
		-- Comments inside the block count as children, so they block removal
		-- instead of being silently deleted.
		local only = body:named_child_count() == 1 and body:named_child(0) or nil
		if not only or only:type() ~= "return_statement" then
			return warn("Body is not a single `return expr;`; can't remove braces")
		end
		local expr = only:named_child(0)
		if not expr then
			return warn("Bare `return;`; can't remove braces")
		end
		new_text = text(expr, buf):gsub("\n" .. unit, "\n")
		if expr:type() == "object" then
			new_text = "(" .. new_text .. ")"
		end
	else
		-- Add braces.
		local expr = body
		if expr:type() == "parenthesized_expression" and expr:named_child(0):type() == "object" then
			expr = expr:named_child(0)
		end
		local indent = indent_of(buf, arrow:start())
		local expr_text = (text(expr, buf):gsub("\n", "\n" .. unit))
		new_text = "{\n" .. indent .. unit .. "return " .. expr_text .. ";\n" .. indent .. "}"
	end

	vim.api.nvim_buf_set_text(buf, sr, sc, er, ec, vim.split(new_text, "\n"))
end

---------------------------------------------------------------------------

local function toggle_arrow_function()
	local buf = vim.api.nvim_get_current_buf()
	local kind, node, arrow = find_target()
	if kind == "arrow" then
		arrow_to_function(buf, node, arrow)
	elseif kind == "function" then
		function_to_arrow(buf, node)
	elseif kind == "generator" then
		warn("Generator functions can't be arrows")
	else
		warn("No arrow function or function declaration under cursor")
	end
end

vim.api.nvim_create_user_command("ToggleArrowFunction", toggle_arrow_function, {})
vim.keymap.set("n", "<leader>cf", toggle_arrow_function, { desc = "Toggle arrow function / named function" })

vim.api.nvim_create_user_command("ToggleArrowBraces", toggle_arrow_braces, {})
vim.keymap.set("n", "<leader>cb", toggle_arrow_braces, { desc = "Add/remove arrow function braces" })

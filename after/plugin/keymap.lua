vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>w", "<Cmd>update<CR>")
vim.keymap.set("n", "<c-x>", ":Ex<CR>")
vim.keymap.set("n", "<leader>nt", ":tabnew<CR>")
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>")
vim.keymap.set("n", "<leader>sh", ":split<CR>")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>h", "<C-w>h")

-- unbind default lsp
vim.keymap.del("n", "grn")
vim.keymap.del({ "n", "v" }, "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")

-- modifier key is either Alt or Ctrl
local mod = jit.os == "Linux" and "M" or "C"

-- map Mod + Number to <Number>gt
-- toggles the open tabs by numbers
for i = 1, 6, 1 do
	vim.keymap.set("n", "<" .. mod .. "-" .. i .. ">", i .. "gt")
end

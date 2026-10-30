vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>w", "<Cmd>update<CR>")
vim.keymap.set("n", "<leader>x", ":Ex<CR>")
vim.keymap.set("n", "<leader>nt", ":tabnew<CR>")
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>")
vim.keymap.set("n", "<leader>sh", ":split<CR>")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>h", "<C-w>h")

-- modifier key is either Alt or Ctrl
local mod = "C"

-- map Mod + Number to <Number>gt
-- toggles the open tabs by numbers
for i = 1, 5, 1 do
	vim.keymap.set("n", "<" .. mod .. "-" .. i .. ">", i .. "gt")
end

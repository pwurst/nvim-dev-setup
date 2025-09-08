local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map({ "n", "x" }, "j", "gj", opts)
map({ "n", "x" }, "k", "gk", opts)

map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics: to loclist" })

map("n", "<leader>us", function()
  vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle spell" })

map("n", "<leader>wk", "<cmd>WhichKey<CR>", { desc = "Show which-key" })
map("n", "<leader>?n", function() require("utils.cheatsheet").show_navigation() end, { desc = "Navigation cheatsheet" })

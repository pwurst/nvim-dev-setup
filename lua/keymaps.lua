local map = vim.keymap.set
local silent = { silent = true, noremap = true }

map("n", "<leader>w", "<cmd>w<cr>", silent)
map("n", "<leader>q", "<cmd>q<cr>", silent)
map("n", "<leader>h", "<cmd>nohlsearch<cr>", silent)

map("n", "<leader>e", "<cmd>Neotree toggle<cr>", silent)

map("n", "<leader>ff", function() pcall(vim.cmd, "Telescope find_files") end, silent)
map("n", "<leader>fg", function() pcall(vim.cmd, "Telescope live_grep") end, silent)
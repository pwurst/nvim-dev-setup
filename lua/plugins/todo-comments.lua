return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	opts = {},
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
		{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search Todos" },
	},
}

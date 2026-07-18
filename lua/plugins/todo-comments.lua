return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	opts = {},
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
		{
			"<leader>st",
			function()
				-- TodoTelescope went away with telescope; grep the same keywords
				-- with a fixed pattern (typing then filters the matches)
				Snacks.picker.grep({
					search = [[\b(TODO|FIXME|FIX|HACK|NOTE|WARN|PERF|BUG|XXX)(\(.*\))?:]],
					live = false,
				})
			end,
			desc = "Search Todos",
		},
	},
}

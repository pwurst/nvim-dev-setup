return {
	-- Side-by-side diffs, file history, and merge-conflict view
	-- (complements gitsigns, which works at hunk level)
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		opts = {},
		keys = {
			-- <leader>gd is taken by gitsigns diffthis, hence gv
			{ "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview (working tree)" },
			{ "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (file)" },
			{ "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "File History (repo)" },
		},
	},
}

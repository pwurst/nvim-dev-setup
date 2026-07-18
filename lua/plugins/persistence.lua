return {
	-- Per-directory session restore (buffers, splits, window layout).
	-- The snacks dashboard "Restore Session" entry picks this up automatically.
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},
}

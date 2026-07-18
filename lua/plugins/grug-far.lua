return {
	-- Project-wide find & replace with live preview (ripgrep-backed)
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		opts = {},
		keys = {
			{
				"<leader>sR",
				function()
					-- transient: buffer closes for good when hidden
					require("grug-far").open({ transient = true })
				end,
				mode = { "n", "v" },
				desc = "Search & Replace",
			},
		},
	},
}

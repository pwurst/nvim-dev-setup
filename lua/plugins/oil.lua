return {
	{
		"stevearc/oil.nvim",
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Oil",
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open Parent Directory" },
		},
		opts = {
			default_file_explorer = true,
			-- Skip the confirmation popup for simple file operations
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				["<C-h>"] = false, -- Prevent conflict if you use C-h for window nav
				["<M-h>"] = "actions.select_split",
			},
		},
	},
}

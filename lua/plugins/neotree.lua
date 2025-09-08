return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer (Neo-tree)" },
		},
		opts = {
			window = {
				position = "left",
				width = 32,
				mappings = {
					["<CR>"] = "open",
					["l"] = "open",
					["h"] = "close_node",
					["v"] = "open_vsplit", -- ← vertical split
					["s"] = "open_split", -- ← horizontal split
					["t"] = "open_tabnew",
					-- optional: handle Alt-v if your terminal sends ESC+v
					["<M-v>"] = "open_vsplit",
					["<A-v>"] = "open_vsplit",
				},
			},
			filesystem = {
				filtered_items = { hide_dotfiles = false, hide_gitignored = true },
			},
		},
	},
}

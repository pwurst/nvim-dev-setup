return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix", -- Modern, flat preset
		spec = {
			{ "<leader>b", group = "Buffer" },
			{ "<leader>c", group = "Code" },
			{ "<leader>d", group = "Debug" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>l", group = "Lazy" },
			{ "<leader>q", group = "Quit/Session" },
			{ "<leader>s", group = "Search" },
			{ "<leader>u", group = "UI" },
			{ "<leader>w", group = "Window" },
			-- Navigation Cheatsheet trigger
			{
				"<leader>?",
				function()
					require("utils.cheatsheet").show_navigation()
				end,
				desc = "Cheatsheet",
			},
		},
	},
}

return {
	"linux-cultist/venv-selector.nvim",
	branch = "regexp",
	dependencies = { "neovim/nvim-lspconfig", "folke/snacks.nvim" },
	ft = "python",
	opts = {
		settings = {
			options = {
				picker = "snacks", -- telescope removed; use snacks.picker
			},
			search = {
				venvs = {
					-- Search common venv locations
					path = vim.fn.expand("~"),
					fd_find_name = ".venv",
				},
			},
		},
	},
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Venv" },
		{ "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached Venv" },
	},
}

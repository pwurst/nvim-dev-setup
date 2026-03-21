-- Detect Kitty graphics protocol support (Ghostty, Kitty, WezTerm, iTerm2)
local function has_image_support()
	local term = vim.env.TERM or ""
	local term_program = vim.env.TERM_PROGRAM or ""
	local multiplexer = vim.env.TMUX or ""
	-- Ghostty reports xterm-ghostty or sets TERM_PROGRAM=ghostty
	return term:find("kitty") ~= nil
		or term_program:find("ghostty") ~= nil
		or term_program:find("iTerm") ~= nil
		or (multiplexer == "" and term:find("xterm") ~= nil and vim.env.KITTY_WINDOW_ID ~= nil)
end

return {
	-- Inline image rendering (Kitty graphics protocol)
	{
		"3rd/image.nvim",
		cond = has_image_support,
		opts = {
			backend = "kitty",
			integrations = {
				markdown = { enabled = true },
			},
			max_width_window_percentage = 60,
			max_height_window_percentage = 40,
		},
	},

	-- Jupyter kernel integration
	{
		"benlubas/molten-nvim",
		dependencies = { "3rd/image.nvim" },
		version = "^1.0.0",
		build = ":UpdateRemotePlugins",
		ft = { "python", "jupyter" },
		init = function()
			-- Use image.nvim for output if available, plain text otherwise
			vim.g.molten_image_provider = has_image_support() and "image.nvim" or "none"
			vim.g.molten_output_win_max_height = 20
			vim.g.molten_auto_open_output = false -- open manually with <leader>js
			vim.g.molten_wrap_output = true
			vim.g.molten_virt_text_output = true -- show short output as virtual text
			vim.g.molten_virt_lines_off_by_1 = true
		end,
		keys = {
			{ "<leader>j", nil, desc = "Jupyter" },
			{ "<leader>ji", "<cmd>MoltenInit<cr>", desc = "Init kernel" },
			{ "<leader>jr", "<cmd>MoltenEvaluateOperator<cr>", desc = "Run cell", expr = true },
			{ "<leader>jl", "<cmd>MoltenEvaluateLine<cr>", desc = "Run line" },
			{ "<leader>ja", "<cmd>MoltenEvaluateAll<cr>", desc = "Run all cells" },
			{ "<leader>jr", "<cmd>MoltenEvaluateVisual<cr>", mode = "v", desc = "Run selection" },
			{ "<leader>jn", "<cmd>MoltenNextCell<cr>", desc = "Next cell" },
			{ "<leader>jp", "<cmd>MoltenPrevCell<cr>", desc = "Prev cell" },
			{ "<leader>jh", "<cmd>MoltenHideOutput<cr>", desc = "Hide output" },
			{ "<leader>js", "<cmd>MoltenShowOutput<cr>", desc = "Show output" },
			{ "<leader>jd", "<cmd>MoltenDelete<cr>", desc = "Delete output" },
			{ "<leader>jR", "<cmd>MoltenRestart!<cr>", desc = "Restart kernel" },
			{ "<leader>jk", "<cmd>MoltenInterrupt<cr>", desc = "Interrupt kernel" },
		},
	},
}

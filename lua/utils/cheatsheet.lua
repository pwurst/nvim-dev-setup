local M = {}

function M.show_navigation()
	local lines = {
		"   🚀 NEOCONFIG CHEATSHEET",
		"   ───────────────────────────────────────────",
		"   [ FILES ]",
		"   -             Open Parent Dir (Oil)       ",
		"   <leader>ff    Find Files                  ",
		"   <leader>fg    Live Grep                   ",
		"   <leader>sr    Resume Last Search          ",
		"",
		"   [ NAVIGATION ]",
		"   Ctrl + h/j/k/l    Move between splits     ",
		"   Shift + h/l       Cycle Buffers           ",
		"   <leader>e         Toggle Explorer Tree    ",
		"",
		"   [ HARPOON ]",
		"   <leader>a     Mark File                   ",
		"   Ctrl + e      Open Menu                   ",
		"   <leader>1-4   Jump to File 1-4            ",
		"",
		"   [ EDITING ]",
		"   Alt + j/k     Move Line Up/Down           ",
		"   v a f         Select Around Function      ",
		"   c i c         Change Inner Class          ",
		"   <leader>us    Toggle Spell Check          ",
		"",
		"   [ DEBUG ]",
		"   <F5>          Start/Continue              ",
		"   <leader>db    Toggle Breakpoint           ",
		"   <leader>du    Toggle Debug UI             ",
		"   ───────────────────────────────────────────",
		"   Press q to close",
	}

	-- Create a float window
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local width = 50
	local height = #lines + 2
	local opts = {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Formatting the header
	vim.api.nvim_buf_add_highlight(buf, -1, "Title", 0, 0, -1)

	-- Close on 'q' or 'Esc'
	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
	vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })

	-- Disable editing in the popup
	vim.bo[buf].modifiable = false
end

return M

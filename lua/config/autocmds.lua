local aug = vim.api.nvim_create_augroup
local auc = vim.api.nvim_create_autocmd

-- ⚡ KEY: Flash the text you just yanked (copied)
auc("TextYankPost", {
	group = aug("HighlightYank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Resize splits if window got resized
auc({ "VimResized" }, {
	group = aug("ResizeSplits", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- Docs Spelling
auc("FileType", {
	pattern = { "markdown", "tex", "text", "gitcommit" },
	group = aug("SpellForDocs", { clear = true }),
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.wrap = true
	end,
})

-- Close some buffers with <q>
auc("FileType", {
	group = aug("CloseWithQ", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

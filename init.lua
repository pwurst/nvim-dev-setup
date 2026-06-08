-- Set <space> as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Load Config
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.providers") -- Optional

-- Load Plugins
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	ui = { border = "rounded" },
	change_detection = { notify = false },
	git = { url_format = "https://github.com/%s.git" },
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = false })

-- Set <space> as leader BEFORE anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local home_ts = vim.fn.expand("~/.cargo/bin")
if not string.find(vim.env.PATH or "", home_ts, 1, true) then
	vim.env.PATH = home_ts .. ":" .. (vim.env.PATH or "")
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Core settings, keymaps, autocmds
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.providers")

-- Load plugins from lua/plugins/* and force HTTPS for GitHub
require("lazy").setup({
	spec = { import = "plugins" },
	change_detection = { notify = false },
	git = { url_format = "https://github.com/%s.git" },
})

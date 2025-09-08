-- Set <space> as leader BEFORE anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

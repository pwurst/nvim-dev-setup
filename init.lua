-- ====================================================================
--  Neovim init.lua (Lazy-based; stable; Noice removed)
-- ====================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Optional: dedicated Python provider venv
do
  local py = vim.fn.expand("~/.virtualenvs/nvim/bin/python")
  if vim.fn.filereadable(py) == 1 then
    vim.g.python3_host_prog = py
  end
end

-- Neo-tree prefers netrw disabled
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git","clone","--filter=blob:none","--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Core config
pcall(require, "opts")
pcall(require, "keymaps")
pcall(require, "autocmds")

-- Plugins
require("lazy").setup({
  spec = { { import = "plugins" } },
  defaults = { lazy = true },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip","matchit","matchparen","tarPlugin","tohtml","tutor","zipPlugin",
      },
    },
  },
})

pcall(vim.cmd, "colorscheme habamax")
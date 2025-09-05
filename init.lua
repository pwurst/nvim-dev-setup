-- ====================================================================
--  Neovim init.lua (modern, Lazy-based; minimal + robust)
--  - Loads plugin specs from lua/plugins/**
--  - Avoids duplicate LSP/cmp setup in init.lua
--  - Optional Python provider pin to a dedicated venv
-- ====================================================================

-- 1) Leader keys must be set before plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2) (Optional) Pin Python provider to a stable venv if present
do
  local py = vim.fn.expand("~/.virtualenvs/nvim/bin/python")
  if vim.fn.filereadable(py) == 1 then
    vim.g.python3_host_prog = py
  end
end

-- 3) Slight startup hygiene (Neo-tree prefers netrw disabled)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 4) Bootstrap lazy.nvim if missing
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 5) Core options / keymaps (guarded requires so missing files won’t error)
pcall(require, "opts")       -- put your vim.opt settings in lua/opts.lua
pcall(require, "keymaps")    -- put your keymaps in lua/keymaps.lua
pcall(require, "autocmds")   -- optional lua/autocmds.lua (yank highlight, etc.)

-- 6) Plugin setup (imports everything under lua/plugins/**)
require("lazy").setup({
  spec = {
    { import = "plugins" },
    -- You can add more trees like:
    -- { import = "plugins.extras" },
  },
  defaults = { lazy = true },          -- lazy-load plugins by default
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = false },       -- set true to auto-check plugin updates
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        -- netrwPlugin disabled above
      },
    },
  },
})

-- 7) (Optional) Set a colorscheme if installed; ignore if missing
pcall(vim.cmd, "colorscheme tokyonight")


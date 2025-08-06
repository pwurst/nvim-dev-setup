-- ~/.config/nvim/init.lua ---------------------------------------------------
-- Neovim entry-point: bootstraps plugin manager, then layers options,
-- plugins, LSP, completion, debugging and key-maps in deterministic order.
-- Patrick Wurster · validated 2025-08-04

------------------------------------------------------------------------------
-- 0️⃣  Globals & leader ------------------------------------------------------
------------------------------------------------------------------------------
vim.g.mapleader      = " " -- <Space> as leader
vim.g.maplocalleader = ","

------------------------------------------------------------------------------
-- 1️⃣  Core Vim options ------------------------------------------------------
------------------------------------------------------------------------------
require("opts") -- all `vim.opt` tweaks
vim.g.python3_host_prog = vim.fn.expand("~/.config/nvim/.pyenvs/nvim/bin/python3")




-- disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- LuaRocks path (if present)
pcall(require, "luarocks.loader")

------------------------------------------------------------------------------
-- 2️⃣  Bootstrap Lazy.nvim ---------------------------------------------------
------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- use system clipboard
vim.opt.clipboard:append("unnamedplus")

------------------------------------------------------------------------------
-- 3️⃣  Plugins ---------------------------------------------------------------
------------------------------------------------------------------------------
require("plugins")

-- python syntax highlighting
-- 1.  Tell Tokyonight which variant you want  (before :colorscheme)
vim.g.tokyonight_style = "moon"            -- or use the opts table in the spec
-- 2.  Load the *base* scheme (name is just "tokyonight")
pcall(vim.cmd.colorscheme, "tokyonight")
-- 3.  Apply your per-Python tweaks so they override the theme’s defaults
pcall(require, "highlight.python")

-- Harpoon v2 legacy‐cache purge (avoids json_encode crash once per boot)
pcall(function()
  local hp, hpd = require("harpoon"), require("harpoon.data")
  hpd.__dangerously_clear_data(hp.config)
end)

------------------------------------------------------------------------------
-- 4️⃣  LSP stack -------------------------------------------------------------
------------------------------------------------------------------------------
require("lsp.diagnostic_icons")
require("lsp.servers")


------------------------------------------------------------------------------
-- 6️⃣  Debugging (DAP) -------------------------------------------------------
-- Python-centric helpers live in lua/dap.lua (auto-loaded by plugin config)
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- 7️⃣  Key-maps --------------------------------------------------------------
------------------------------------------------------------------------------
require("keymaps")

------------------------------------------------------------------------------
-- EOF -----------------------------------------------------------------------

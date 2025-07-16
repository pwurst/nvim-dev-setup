-- ~/.config/nvim/init.lua ---------------------------------------------------
-- Neovim entry‑point: bootstraps plugin manager, then layers options,
-- plugins, LSP, completion, debugging and key‑maps in deterministic order.
-- Patrick Wurster · validated 2025‑07‑16

------------------------------------------------------------------------------
-- 0️⃣  Globals & leader -------------------------------------------------------
------------------------------------------------------------------------------
vim.g.mapleader = " "         -- <Space> as leader keeps terminal chords clean
vim.g.maplocalleader = ","

------------------------------------------------------------------------------
-- 1️⃣  Core Vim options ------------------------------------------------------
------------------------------------------------------------------------------
-- Delegate most opts to lua/opts.lua (keeps init.lua concise)
require("opts")

-- Let external plugins know which python interpreter to use
vim.g.python3_host_prog = vim.fn.expand("~/.config/nvim/.pyenvs/nvim/bin/python3")

-- Disable unused language providers to shave startup‑time
vim.g.loaded_node_provider  = 0
vim.g.loaded_perl_provider  = 0
vim.g.loaded_ruby_provider  = 0

-- Add LuaRocks‑installed modules to runtime path if available
pcall(require, "luarocks.loader")

------------------------------------------------------------------------------
-- 2️⃣  Bootstrap Lazy.nvim plugin manager ------------------------------------
------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Always use the system clipboard (optional, but convenient)
vim.opt.clipboard:append("unnamedplus")

------------------------------------------------------------------------------
-- 3️⃣  Plugins ---------------------------------------------------------------
require("plugins")

-- Harpoon v2 occasionally writes function references into its on‑disk
-- cache causing `json_encode` failures (E474).  Nuking any legacy cache
-- once at startup prevents the crash without touching user data in
-- future sessions.
pcall(function()
  local hp  = require("harpoon")
  local hpd = require("harpoon.data")
  hpd.__dangerously_clear_data(hp.config)
end)

------------------------------------------------------------------------------
-- 4️⃣  LSP stack -------------------------------------------------------------
------------------------------------------------------------------------------
-- Diagnostic icons, Mason, LSPConfig and Conform helper modules live under
-- lua/lsp/* .  Having them split keeps responsibilities clear.
require("lsp.diagnostic_icons")
require("lsp.servers")
require("lsp.format")

------------------------------------------------------------------------------
-- 5️⃣  Autocompletion --------------------------------------------------------
------------------------------------------------------------------------------
-- nvim‑cmp base configuration.  Note that cmp_setup.lua is also `require`d
-- from the plugin spec – this explicit call guarantees the mappings are
-- present even when plugins defer‑load.

------------------------------------------------------------------------------
-- 6️⃣  Debugging (DAP) -------------------------------------------------------
------------------------------------------------------------------------------
-- Only Python‑specific DAP helpers right now, see lua/dap/*.lua if extended.
-- (No explicit require needed; setup happens inside plugin config.)

------------------------------------------------------------------------------
-- 7️⃣  Key‑maps --------------------------------------------------------------
------------------------------------------------------------------------------
-- All custom keybindings live in lua/keymaps.lua
require("keymaps")

------------------------------------------------------------------------------
-- EOF -----------------------------------------------------------------------


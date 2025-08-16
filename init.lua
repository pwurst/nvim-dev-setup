-- ~/.config/nvim/init.lua ---------------------------------------------------
-- Neovim entry-point: bootstraps plugin manager, then layers options,
-- plugins, LSP, completion, debugging and key-maps in deterministic order.
-- Patrick Wurster · validated 2025-08-04

------------------------------------------------------------------------------
-- 0️⃣  Globals & leader ------------------------------------------------------
------------------------------------------------------------------------------
vim.g.mapleader      = " "
vim.g.maplocalleader = ","

------------------------------------------------------------------------------
-- 1️⃣  Core Vim options ------------------------------------------------------
------------------------------------------------------------------------------
require("opts") -- all `vim.opt` tweaks

-- Python providers
vim.g.python3_host_prog     = vim.fn.expand("~/.config/nvim/.pyenvs/nvim/bin/python3")
vim.g.loaded_python_provider = 0            -- disable legacy py2 provider

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
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/parsers")
-- use system clipboard
vim.opt.clipboard:append("unnamedplus")

------------------------------------------------------------------------------
-- 3️⃣  Plugins (Lazy spec import) -------------------------------------------
------------------------------------------------------------------------------
require("lazy").setup({
  spec = {
    { import = "plugins" },    -- loads every file under lua/plugins/*.lua
  },
  change_detection = { notify = false },

  -- If you want to avoid SSH for public plugins, uncomment:
  -- git = { url_format = "https://github.com/%s.git" },
})

-- If a legacy lua/plugins.lua file exists, it will shadow the folder.
-- Remove or rename it to avoid "Invalid spec module: `plugins`".
--   mv ~/.config/nvim/lua/plugins.lua ~/.config/nvim/lua/plugins_old.lua

------------------------------------------------------------------------------
-- 4️⃣  Colorscheme & syntax tweaks ------------------------------------------
------------------------------------------------------------------------------
-- Tokyonight variant is set in its plugin spec via opts = { style = "moon" }.
pcall(vim.cmd.colorscheme, "tokyonight")

-- If you keep per-language highlight tweaks:
pcall(require, "highlight.python")

-- Harpoon v2 legacy-cache purge (guarded)
pcall(function()
  local ok_hp, hp  = pcall(require, "harpoon")
  local ok_hpd, hd = pcall(require, "harpoon.data")
  if ok_hp and ok_hpd and hd.__dangerously_clear_data then
    hd.__dangerously_clear_data(hp.config)
  end
end)

-- Whitespace UI (uses mini.trailspace); guard in case plugin not loaded yet
pcall(require, "ui.whitespace")

------------------------------------------------------------------------------
-- 5️⃣  LSP stack -------------------------------------------------------------
------------------------------------------------------------------------------
-- Keep server setup inside lua/plugins/lsp.lua (Lazy-managed).
-- Icons/diagnostic visuals don’t depend on Mason; safe to require here.
pcall(require, "lsp.diagnostic_icons")

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


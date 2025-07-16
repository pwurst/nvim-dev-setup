-- lua/opts.lua --------------------------------------------------------------
-- Core editor options for Neovim 0.11+ (Lua table API)
-- Patrick Wurster · revised 2025‑07‑16

local o = vim.opt  -- shorthand

-----------------------------------------------------------------------------
-- 1️⃣  Basic UI -------------------------------------------------------------
-----------------------------------------------------------------------------
o.number         = true   -- absolute line numbers
o.relativenumber = true   -- relative numbers for motions
o.signcolumn     = "yes"  -- keep gutter visible
o.cursorline     = true   -- highlight current line

-----------------------------------------------------------------------------
-- 2️⃣  UI enhancements ------------------------------------------------------
-----------------------------------------------------------------------------
o.scrolloff      = 8      -- keep 8 lines above/below cursor
o.sidescrolloff  = 8      -- keep 8 columns to left/right

o.wrap           = false  -- disable soft wrapping

o.list           = true   -- show whitespace characters
o.listchars      = {
  tab      = "»·",  -- xxx··  (visible tab)
  trail    = "·",   -- trailing space
  extends  = "›",   -- line extends right
  precedes = "‹",   -- line extends left
}

-----------------------------------------------------------------------------
-- 3️⃣  Editing / indentation ----------------------------------------------
-----------------------------------------------------------------------------
o.expandtab     = true  -- use spaces for <Tab>
o.shiftwidth    = 2     -- size for indents with << and >>
o.tabstop       = 2     -- visual width of a real tab
o.softtabstop   = 2     -- spaces inserted/deleted with <Tab>/<BS>
o.smartindent   = true  -- auto‑indent on new line

-----------------------------------------------------------------------------
-- 4️⃣  Search ---------------------------------------------------------------
-----------------------------------------------------------------------------
o.incsearch     = true  -- incremental search
o.hlsearch      = false -- turn off persistent highlighting

o.ignorecase    = true  -- case‑insensitive unless...
o.smartcase     = true  -- ...pattern contains upper‑case

-----------------------------------------------------------------------------
-- 5️⃣  Command‑line / completion -------------------------------------------
-----------------------------------------------------------------------------
o.cmdheight     = 1     -- one‑line command bar
o.pumheight     = 10    -- pop‑up menu height

-- nvim‑cmp recommendation
o.completeopt   = { "menu", "menuone", "noselect" }

-----------------------------------------------------------------------------
-- 6️⃣  Performance / sensitivity -------------------------------------------
-----------------------------------------------------------------------------
o.updatetime    = 300   -- CursorHold delay (ms)
o.timeoutlen    = 500   -- mapped key sequence timeout

o.mouse         = "a"   -- enable mouse everywhere
o.clipboard     = "unnamedplus"  -- use system clipboard

-----------------------------------------------------------------------------
-- 7️⃣  File handling / undo -------------------------------------------------
-----------------------------------------------------------------------------
o.swapfile      = false -- no .swp files
o.backup        = false -- no backups
o.undofile      = true  -- persistent undo

-----------------------------------------------------------------------------
-- 8️⃣  Folding behaviour ----------------------------------------------------
-----------------------------------------------------------------------------
-- Use Treesitter/indent/ufo/etc. during initial render, then switch to
-- manual so folds don't collapse on every InsertLeave (Esc).

-- reasonable defaults
o.foldenable     = true   -- keep folds enabled
o.foldmethod     = "indent"  -- or "expr" if ufo sets up Treesitter
o.foldlevel      = 99     -- open most folds by default
o.foldlevelstart = 99

-- Freeze foldmethod after opening
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.schedule(function()
      vim.wo.foldmethod = "manual"
    end)
  end,
})

-- Optional: manual re‑compute helper (mapped in keymaps.lua)
--   <leader>uf  : update folds once, then freeze again
vim.api.nvim_create_user_command("UpdateFolds", function()
  local method = "indent"  -- change if you use expr/Treesitter
  vim.wo.foldmethod = method
  vim.cmd("normal! zx")    -- recompute folds
  vim.wo.foldmethod = "manual"
end, { desc = "Recompute & freeze folds" })

-- end opts.lua -------------------------------------------------------------


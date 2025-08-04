-- ~/.config/nvim/lua/opts.lua ----------------------------------------------
-- Core editor options (Neovim 0.11+)
-- Patrick Wurster · revised 2025-08-04

local o = vim.opt

-- 1. Basic UI ---------------------------------------------------------------
o.number         = true
o.relativenumber = true
o.signcolumn     = "yes"
o.cursorline     = true

-- 2. UI enhancements --------------------------------------------------------
o.scrolloff      = 8
o.sidescrolloff  = 8
o.wrap           = false         -- global off (Markdown autocmd adds local)
o.list           = true
o.listchars      = { tab = "»·", trail = "·", extends = "›", precedes = "‹" }

-- 3. Indentation ------------------------------------------------------------
o.expandtab      = true
o.shiftwidth     = 2
o.tabstop        = 2
o.softtabstop    = 2
o.smartindent    = true

-- 4. Search -----------------------------------------------------------------
o.incsearch      = true
o.hlsearch       = false
o.ignorecase     = true
o.smartcase      = true

-- 5. Completion / cmd-line --------------------------------------------------
o.cmdheight      = 1
o.pumheight      = 10
o.completeopt    = { "menu", "menuone", "noselect" }

-- 6. Performance ------------------------------------------------------------
o.updatetime     = 300
o.timeoutlen     = 500
o.mouse          = "a"

-- 7. Files ------------------------------------------------------------------
o.swapfile       = false
o.backup         = false
o.undofile       = true

-- 8. Folding ----------------------------------------------------------------
o.foldenable     = true
o.foldmethod     = "indent"
o.foldlevel      = 99
o.foldlevelstart = 99

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
  vim.schedule(function() vim.wo[args.buf].foldmethod = "manual" end)
  end,
})

vim.api.nvim_create_user_command("UpdateFolds", function()
vim.wo.foldmethod = "indent"
vim.cmd("normal! zx")
vim.wo.foldmethod = "manual"
end, { desc = "Recompute & freeze folds" })

-- ── Auto-wrap for Markdown & TeX ───────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
  group   = vim.api.nvim_create_augroup("WrapOnMarkdownTeX", { clear = true }),
                            pattern = { "markdown", "tex", "plaintex", "latex" },
                            callback = function()
                            vim.opt_local.textwidth = 80
                            local fo = vim.opt_local.formatoptions
                            fo:remove({ "o" })
                            fo:append({ "t", "c", "q", "j", "n" })
                            vim.opt_local.wrap      = true
                            vim.opt_local.linebreak = true
                            end,
})

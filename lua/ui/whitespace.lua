-- ~/.config/nvim/lua/ui/whitespace.lua --------------------------------------
-- Visualize whitespace and make trailing spaces obvious.

-- enable "list" globally
vim.opt.list = true

-- define glyphs
vim.opt.listchars = {
  space    = "·",   -- dots for intra-line spaces
  trail    = "●",   -- strong marker for trailing spaces (EOL)
  tab      = "│·",  -- tab "guide"
  extends  = "›",
  precedes = "‹",
  nbsp     = "␣",
}

-- make them readable under dark themes
vim.api.nvim_set_hl(0, "Whitespace", { link = "NonText" })  -- general spaces
vim.api.nvim_set_hl(0, "NonText",    { default = true })    -- keep theme default
vim.api.nvim_set_hl(0, "SpecialKey", { default = true })

-- optional: per-filetype disable list (file explorers, dashboards, etc.)
local disable_list_ft = {
  "alpha", "neo-tree", "lazy", "mason", "help", "Trouble", "toggleterm",
  "dashboard",
}
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("WhitespaceToggle", { clear = true }),
  callback = function(ev)
    for _, ft in ipairs(disable_list_ft) do
      if ev.match == ft then
        vim.opt_local.list = false
        return
      end
    end
  end,
})


local aug = vim.api.nvim_create_augroup

-- Use new 'vim.hl' API if available; fall back to legacy 'vim.highlight'
local function do_on_yank()
  if vim.hl and vim.hl.on_yank then
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 120 })
  elseif vim.highlight and vim.highlight.on_yank then
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 120 })
  end
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug("YankHighlight", { clear = true }),
  callback = do_on_yank,
})

vim.api.nvim_create_autocmd("FileType", {
  group = aug("ProseSettings", { clear = true }),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
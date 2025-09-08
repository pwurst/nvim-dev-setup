local aug = vim.api.nvim_create_augroup
local auc = vim.api.nvim_create_autocmd

auc("FileType", {
  pattern = { "markdown", "tex", "plaintex" },
  group = aug("SpellForDocs", { clear = true }),
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us" }
  end,
})

auc("FileType", {
  pattern = { "python" },
  group = aug("PythonIndent", { clear = true }),
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

local M = {}

function M.on_attach(_, bufnr)
local opts = { buffer = bufnr, silent = true }

-- Navigation -----------------------------------------------------------
vim.keymap.set("n", "gd", vim.lsp.buf.definition,  opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references,  opts)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "K",  vim.lsp.buf.hover,       opts)

-- Code actions / refactor ---------------------------------------------
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,       opts)

-- Formatting (falls back to Conform’s :Format) -------------------------
vim.keymap.set("n", "<leader>f", function()
vim.lsp.buf.format({ async = true })
end, opts)
end

return M

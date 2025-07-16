-- ~/.config/nvim/lua/lsp/on_attach.lua
local M = {}

function M.on_attach(client, bufnr)
  local bufmap = function(mode, lhs, rhs)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
  end

  bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  bufmap('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
  -- add your other keymaps…
end

return M


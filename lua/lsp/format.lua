-- ~/.config/nvim/lua/lsp/format.lua
local conform_ok, conform = pcall(require, "conform")
if not conform_ok then return end

conform.setup({
  log_level = vim.log.levels.WARN,

  -- Per-buffer opt-out:
  --   :let b:disable_format_on_save = 1
  format_on_save = function(bufnr)
    if vim.b[bufnr] and vim.b[bufnr].disable_format_on_save then
      return
    end
    return { lsp_fallback = true, timeout_ms = 1500 }
  end,

  formatters_by_ft = {
    lua        = { "stylua" },
    python     = { "black", "isort", "lsp" },
    r          = { "styler" },
    javascript = { "eslint_d", "prettier" },
    typescript = { "eslint_d", "prettier" },
    json       = { "prettier" },
    html       = { "prettier" },
    css        = { "prettier" },
    markdown   = { "prettier" },
  },
})

-- On-demand formatting
vim.keymap.set(
  "n",
  "<leader>cf",
  function() conform.format({ async = true }) end,
  { desc = " Format buffer (Conform)" }
)

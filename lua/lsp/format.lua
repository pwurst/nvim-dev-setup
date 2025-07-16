require("conform").setup({
  format_on_save = { timeout_ms = 1500 },
  format_options = {
    async  = false,
    logger = vim.log.levels.WARN,
  },
  condition = function(bufnr)
    return not vim.b[bufnr].disable_format_on_save
  end,
  formatters_by_ft = {
    python     = { "black", "isort", "lsp" },
    r          = { "styler" },
    javascript = { "eslint_d", "prettier" },
    html       = { "prettier" },
    css        = { "prettier" },
    json       = { "prettier" },
    markdown   = { "prettier" },
    lua        = { "stylua" },
  },
})


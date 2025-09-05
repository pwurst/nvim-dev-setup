return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable = vim.b[bufnr].disable_format_on_save or vim.g.disable_format_on_save
      if disable then return end
      return { lsp_fallback = true, timeout_ms = 2000 }
    end,
    formatters_by_ft = {
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      python = { "ruff_format", "black" },
      lua = { "stylua" },
      markdown = { "mdformat" },
      json = { "jq" },
      yaml = { "yq" },
    },
  },
  config = function(_, opts) require("conform").setup(opts) end,
}
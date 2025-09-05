-- ~/.config/nvim/lua/plugins/conform.lua
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable with: vim.b[bufnr].disable_format_on_save = true
        if vim.g.disable_autoformat or vim.b[bufnr].disable_format_on_save then
          return
        end
        return { timeout_ms = 2000, lsp_fallback = true }
      end,
      formatters_by_ft = {
        python = { "ruff_format", "black" },
        sh     = { "shfmt" },
        bash   = { "shfmt" },
        zsh    = { "shfmt" },
        lua    = { "stylua" },
        json   = { "jq" },
        yaml   = { "yamlfmt", "prettierd", "prettier", "dprint" },
        markdown = { "prettierd", "prettier", "mdformat" },
        ["*"]  = { "trim_whitespace" },
      },
    },
  },
}

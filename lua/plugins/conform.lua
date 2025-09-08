return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      format_on_save = function(bufnr)
        local max_size = 500 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > max_size then return nil end
        return { timeout_ms = 2000, lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        markdown = { "mdformat" },
        yaml = { "yamlfmt" },
      },
    },
  },
}

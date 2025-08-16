return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local nls = require("null-ls")
      local sources = {
        -- Python (fast path)
        nls.builtins.diagnostics.ruff,
        nls.builtins.formatting.ruff,
        -- Shell
        nls.builtins.diagnostics.shellcheck,
        nls.builtins.formatting.shfmt,
      }
      nls.setup({
        sources = sources,
        on_attach = function(client, bufnr)
          -- Intentionally empty: Conform handles format-on-save.
        end,
      })
    end,
  },
}
local conform = require("conform")

conform.setup({
  log_level = vim.log.levels.WARN,     -- reduce noise

  format_on_save = {
    lsp_fallback = true,              -- fall back to lsp.buf.format if no formatter
    timeout_ms   = 1500,
  },

  condition = function(bufnr)          -- per‑buffer opt‑out via :let b:disable_format_on_save=1
  return not vim.b[bufnr].disable_format_on_save
  end,

  formatters_by_ft = {
    lua        = { "stylua" },

    python     = { "black", "isort", "lsp" },
    r          = { "styler" },           -- requires R + styler pkg

    javascript = { "eslint_d", "prettier" },
    typescript = { "eslint_d", "prettier" },
    json       = { "prettier" },
    html       = { "prettier" },
    css        = { "prettier" },
    markdown   = { "prettier" },
  },
})

-- helper key‑map (normal mode) – <leader>cf formats current buffer on demand
vim.keymap.set(
  "n",
  "<leader>cf",
  function() conform.format({ async = true }) end,
               { desc = " Format buffer (Conform)" }
)

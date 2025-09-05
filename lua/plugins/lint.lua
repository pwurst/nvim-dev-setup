-- ~/.config/nvim/lua/plugins/lint.lua
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        sh     = { "shellcheck" },
        bash   = { "shellcheck" },
        zsh    = { "shellcheck" },
        -- For Python, prefer Ruff LSP diagnostics; if you don't use it, uncomment:
        -- python = { "ruff" },
      }
      local aug = vim.api.nvim_create_augroup("NvimLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
        group = aug,
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
}

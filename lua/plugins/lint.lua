return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "InsertLeave" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },
    }
    local function try_lint() lint.try_lint() end
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, { callback = try_lint })
  end,
}
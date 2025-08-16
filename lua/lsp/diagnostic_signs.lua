-- Central place to configure diagnostic signs without using :sign-define (deprecated)
local icons = {
  ERROR = "",
  WARN  = "",
  INFO  = "",
  HINT  = "",
}

-- Neovim 0.10+ syntax. If you're on 0.9, this also works.
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.ERROR,
      [vim.diagnostic.severity.WARN]  = icons.WARN,
      [vim.diagnostic.severity.INFO]  = icons.INFO,
      [vim.diagnostic.severity.HINT]  = icons.HINT,
    },
  },
})
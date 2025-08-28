return {
  "quarto-dev/quarto-nvim",
  ft = { "quarto", "markdown" },
  dependencies = {
    "jmbuhr/otter.nvim",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    lspFeatures = {
      languages = { "python", "r", "julia", "bash" },
      chunks = "all",
      diagnostics = { enabled = true, triggers = { "BufWritePost" } },
    },
    codeRunner = { enabled = false },
  },
}

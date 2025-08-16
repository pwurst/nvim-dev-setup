-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSInstall", "TSInstallSync", "TSUpdate", "TSUpdateSync", "TSInstallInfo" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "lua", "python", "bash", "markdown", "json", "regex" },
      highlight = { enable = true },
      indent    = { enable = true },
      auto_install = true,
      parser_install_dir = vim.fn.stdpath("data") .. "/parsers",
    },
  },
}


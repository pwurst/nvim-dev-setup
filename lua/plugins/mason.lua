return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = { ui = { border = "rounded" } },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "pyright",
        "ruff",
        "lua_ls",
        "texlab",
        "html",
        "cssls",
        "marksman",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    opts = {
      ensure_installed = {
        "ruff",
        "black",
        "stylua",
        "mdformat",
        "yamlfmt",
        "debugpy",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
}

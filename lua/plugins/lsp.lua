-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "folke/lazydev.nvim", -- Neovim/Lua typings (optional but recommended)
    },
    config = function()
      local on_attach    = require("lsp.on_attach").on_attach
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("lsp.servers").setup(on_attach, capabilities)
    end,
  },
}


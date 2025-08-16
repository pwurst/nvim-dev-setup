-- ~/.config/nvim/lua/plugins/cmp.lua
-- Note: you referenced `require("cmp_setup")`; keep your file at lua/cmp_setup.lua
return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",           "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",           "rafamadriz/friendly-snippets",
      "windwp/nvim-autopairs",      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function() require("cmp_setup") end,
  },
}


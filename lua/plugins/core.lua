-- ~/.config/nvim/lua/plugins/core.lua
return {
  { "folke/lazy.nvim", version = false },        -- bootstrap (safety)
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function() require("mini.icons").setup() end,
  },
}


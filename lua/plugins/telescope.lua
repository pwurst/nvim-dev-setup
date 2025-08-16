-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<Leader>fg", "<Cmd>Telescope live_grep<CR>",  desc = "Grep (ripgrep)" },
    },
    opts = {
      defaults = { layout_config = { width = 0.9 } },
    },
  },
}


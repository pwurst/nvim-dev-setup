-- ~/.config/nvim/lua/plugins/harpoon.lua
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    keys = {
      { "<Leader>a", function() require("harpoon"):list():append() end, desc = "Harpoon add file" },
      { "<Leader>h", function() require("harpoon").ui:toggle_quick_menu() end, desc = "Harpoon menu" },
      { "<Leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<Leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
      { "<Leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
      { "<Leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
    },
    opts = {},
  },
}


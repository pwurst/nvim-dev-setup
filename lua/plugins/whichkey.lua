return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    win = { border = "rounded" }, -- v3: use `win` (not `window`)
  },
  config = function(_, opts)
  local wk = require("which-key")
  wk.setup(opts)

  -- Harpoon helpers
  local harpoon = require("harpoon")
  local function hlist() return harpoon:list() end

  -- v3 spec
  wk.add({
    { "<leader>?",  group = "Help" },
    { "<leader>?n", function() require("utils.cheatsheet").show_navigation() end, desc = "Navigation tips" },

         { "<leader>d",  group = "DAP" },
         { "<leader>du", function() require("dapui").toggle() end,                  desc = "Toggle UI" },

         { "<leader>e",  "<cmd>Neotree toggle<CR>",                                  desc = "Explorer (Neo-tree)" },

         { "<leader>f",  group = "Find" },
         { "<leader>ff", "<cmd>Telescope find_files<CR>",                           desc = "Files" },
         { "<leader>fg", "<cmd>Telescope live_grep<CR>",                            desc = "Grep" },

         { "<leader>h",  group = "Harpoon" },
         { "<leader>h1", function() hlist():select(1) end,                          desc = "Go to 1" },
         { "<leader>h2", function() hlist():select(2) end,                          desc = "Go to 2" },
         { "<leader>h3", function() hlist():select(3) end,                          desc = "Go to 3" },
         { "<leader>h4", function() hlist():select(4) end,                          desc = "Go to 4" },
         { "<leader>ha", function() hlist():add() end,                              desc = "Add file" },
         { "<leader>hh", function() harpoon.ui:toggle_quick_menu(hlist()) end,      desc = "Toggle menu" },

         { "<leader>u",  group = "UI/Toggle" },
         -- We already mapped <leader>us in keymaps.lua; add desc only so which-key shows it.
         { "<leader>us", desc = "Toggle spell" },
  })
  end,
}

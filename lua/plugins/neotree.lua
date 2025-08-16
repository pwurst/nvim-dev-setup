-- ~/.config/nvim/lua/plugins/neotree.lua
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- optional, but nice to have if you use devicons
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree",
    keys = {
      { "<Leader>e", "<Cmd>Neotree toggle<CR>", desc = "File Explorer" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = { visible = true },
        window = {
          -- mappings that apply only inside the Neo-tree buffer
          mappings = {
            -- navigation
            ["l"] = "open",
            ["h"] = "close_node",

            -- file ops
            ["a"] = { "add",    config = { show_path = "relative" } },
            ["r"] = "rename",
            ["d"] = "delete",
            ["c"] = "copy",
            ["x"] = "cut",
            ["p"] = "paste",
            ["R"] = "refresh",

            -- splits & tab
            ["v"] = "open_vsplit",
            ["s"] = "open_split",
            ["t"] = "open_tabnew",

            -- disable default <space>
            ["<space>"] = "none",
          },
        },
      },
    },
  },
}


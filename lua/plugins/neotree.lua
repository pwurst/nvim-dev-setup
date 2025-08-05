-- lua/plugins/neotree.lua
require("neo-tree").setup({
  filesystem = {
    window = {
      -- ⬇︎ mappings that apply **only** inside the Neo-tree buffer
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",

        -- file ops
        ["a"] = { "add",     config = { show_path = "relative" } },
        ["r"] = "rename",
        ["d"] = "delete",
        ["c"] = "copy",
        ["x"] = "cut",
        ["p"] = "paste",
        ["R"] = "refresh",

        -- splits & tab
        ["v"] = "open_vsplit",      -- vertical split
        ["s"] = "open_split",       -- horizontal
        ["t"] = "open_tabnew",

        ["<space>"] = "none",       -- disable default <space>
      },
    },
  },
})


-- ~/.config/nvim/lua/plugins/neotree_mappings.lua
-- Ensure Neo-tree uses valid v3.x clipboard actions
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.window = opts.window or {}
      opts.window.mappings = opts.window.mappings or {}
      opts.window.mappings["x"] = "cut_to_clipboard"
      opts.window.mappings["c"] = opts.window.mappings["c"] or "copy_to_clipboard"
      opts.window.mappings["p"] = opts.window.mappings["p"] or "paste_from_clipboard"
      return opts
    end,
  },
}

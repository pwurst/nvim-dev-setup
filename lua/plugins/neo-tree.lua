return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      follow_current_file = { enabled = true, leave_dirs_open = true },
      hijack_netrw_behavior = "open_default",
    },
    window = {
      mappings = {
        ["x"] = "cut_to_clipboard",
        ["c"] = "copy_to_clipboard",
        ["p"] = "paste_from_clipboard",
      },
    },
  },
}
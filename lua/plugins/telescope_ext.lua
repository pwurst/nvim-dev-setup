return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      pcall(require("telescope").load_extension, "ui-select")
    end,
  },
}
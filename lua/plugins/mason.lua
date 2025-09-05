return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  cmd = { "Mason", "MasonInstall", "MasonUpdate" },
  config = function() require("mason").setup({}) end,
}
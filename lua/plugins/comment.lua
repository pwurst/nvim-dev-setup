-- lua/plugins/comment.lua
return {
  "numToStr/Comment.nvim",
  opts = {
    mappings = { basic = false, extra = false }, -- we provide our own leader maps
  },
}


-- lua/plugins/indent-guides.lua
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = {
      char = "│",        -- alternatives: "┆", "▏"
      tab_char = "│",
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
        "help","alpha","neo-tree","Trouble","lazy","mason",
        "markdown","gitcommit","toggleterm",
      },
      buftypes = { "terminal", "nofile", "quickfix" },
    },
    whitespace = { remove_blankline_trail = false },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
    vim.cmd [[highlight IblScope guifg=#888888 gui=nocombine]]
  end,
}


-- ~/.config/nvim/lua/plugins/noice.lua
return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",  -- <- notifier backend
  },
  event = "VeryLazy",
  opts = {
    lsp = {
      -- Fix the two markdown warnings:
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    -- If you had routes using view = "notify", they’ll now work via nvim-notify.
  },
}


-- lua/plugins/none-ls.lua
return {
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    config = function()
      local nls = require("null-ls")  -- module name stays "null-ls"
      require("mason-null-ls").setup({
        ensure_installed = { "shellcheck" },
        automatic_installation = true,
      })
      nls.setup({
        sources = {
          nls.builtins.diagnostics.shellcheck,   -- <- DIAGNOSTICS (no custom 'method' key)
          nls.builtins.code_actions.shellcheck,
        },
        update_in_insert = false,
        debounce = 150,
      })
    end,
  },
}


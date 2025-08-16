return {
  -- Successor to neodev; provides excellent types for vim & many plugins
  "folke/lazydev.nvim",
  ft = "lua",  -- only load for Lua buffers
  opts = {
    -- Detect libs from installed plugins automatically
    library = { plugins = { "nvim-dap-ui", "neotest", "plenary.nvim" } },
  },
}


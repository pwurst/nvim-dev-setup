-- ~/.config/nvim/lua/plugins.lua -------------------------------------------
-- Central Lazy-managed plugin registry
-- Patrick Wurster · revised 2025-08-04

return require("lazy").setup({

  ---------------------------------------------------------------------------
  -- Core / utility ----------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "echasnovski/mini.nvim",
    version = false,
    config  = function() require("mini.icons").setup() end,
  },                                               -- ← comma **required**

  ---------------------------------------------------------------------------
  --  LSP, completion, diagnostics & formatting  ----------------------------
  ---------------------------------------------------------------------------
  { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },

  { "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",
  },

  { "neovim/nvim-lspconfig", dependencies = "hrsh7th/cmp-nvim-lsp" },

  -- nvim-cmp + LuaSnip ------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",
      "rafamadriz/friendly-snippets",
      "windwp/nvim-autopairs",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function() require("cmp_setup") end,
  },

  -- none-ls (diagnostics **and** formatting) -------------------------------
  {
    "nvimtools/none-ls.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
    local nls = require("null-ls")
    nls.setup({
      sources = {
        -- diagnostics
        nls.builtins.diagnostics.eslint_d,
        nls.builtins.diagnostics.flake8,

        -- formatting
        nls.builtins.formatting.prettier,
        nls.builtins.formatting.black,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.isort,
      },

      -- auto-format on save
      on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        local grp = vim.api.nvim_create_augroup("NoneLSFormat", { clear = true })
        vim.api.nvim_clear_autocmds({ group = grp, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = grp,
          buffer = bufnr,
          callback = function() vim.lsp.buf.format({ async = false }) end,
        })
        end
        end,
    })
    end,
  },

  ---------------------------------------------------------------------------
  --  (other plugin specs go here, each ending with a comma)                --
  ---------------------------------------------------------------------------

})  -- ← closes the table and Lazy.setup call

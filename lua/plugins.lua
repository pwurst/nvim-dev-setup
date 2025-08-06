-- ~/.config/nvim/lua/plugins.lua -------------------------------------------
-- Central Lazy-managed plugin registry
-- Patrick Wurster · restored 2025-08-05
---------------------------------------------------------------------------
return require("lazy").setup({

  -------------------------------------------------------------------------
  -- 0. Core / utility -----------------------------------------------------
  -------------------------------------------------------------------------
  {
    "folke/lazy.nvim",          -- bootstrap itself (safety in case)
    version = false,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,                -- many plugins depend on it
  },
  {
    "echasnovski/mini.nvim",    -- minimal Lua helper collection
    version = false,
    config  = function() require("mini.icons").setup() end,
  },

  {
  "folke/tokyonight.nvim",
  lazy = false,                      -- load immediately on startup
  priority = 1000,                   -- so it loads before everything else
  opts = { style = "moon" },         -- ← variant
},

  -------------------------------------------------------------------------
  -- 1. UI enhancements ----------------------------------------------------
  -------------------------------------------------------------------------
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch       = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd          = "Neotree",
    keys = {
      { "<Leader>e", "<Cmd>Neotree toggle<CR>", desc = "File Explorer" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = { filtered_items = { visible = true } },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    tag          = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd          = "Telescope",
    keys = {
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<Leader>fg", "<Cmd>Telescope live_grep<CR>",  desc = "Grep (ripgrep)" },
    },
    opts = { defaults = { layout_config = { width = 0.9 } } },
  },
  {
    "ThePrimeagen/harpoon",
    branch       = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event        = "VeryLazy",
    keys = {
      { "<Leader>a", function() require("harpoon"):list():append() end,
        desc = "Harpoon add file" },
      { "<Leader>h", function() require("harpoon").ui:toggle_quick_menu() end,
        desc = "Harpoon menu" },
      { "<Leader>1", function() require("harpoon"):list():select(1) end,
        desc = "Harpoon 1" },
      { "<Leader>2", function() require("harpoon"):list():select(2) end,
        desc = "Harpoon 2" },
      { "<Leader>3", function() require("harpoon"):list():select(3) end,
        desc = "Harpoon 3" },
      { "<Leader>4", function() require("harpoon"):list():select(4) end,
        desc = "Harpoon 4" },
    },
    opts = {},   -- use defaults
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts  = { options = { theme = "auto" } },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {},
  },

  -------------------------------------------------------------------------
  -- 2. Treesitter ----------------------------------------------------------
  -------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      ensure_installed = { "lua", "python", "bash", "markdown", "json" },
      highlight = { enable = true },
      indent    = { enable = true },
    },
  },

  -------------------------------------------------------------------------
  -- 3. Git integration -----------------------------------------------------
  -------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts  = {},
  },

  -------------------------------------------------------------------------
  -- 4. LSP, completion, diagnostics & formatting --------------------------
  -------------------------------------------------------------------------
  { "williamboman/mason.nvim",          build = ":MasonUpdate",  config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",
  },
  { "neovim/nvim-lspconfig",            dependencies = "hrsh7th/cmp-nvim-lsp" },

  -- nvim-cmp & LuaSnip -----------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",           "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",           "rafamadriz/friendly-snippets",
      "windwp/nvim-autopairs",      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function() require("cmp_setup") end,
  },

  -- none-ls (diagnostics & formatting) -------------------------------------
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          -- diagnostics -------------------------
          nls.builtins.diagnostics.eslint_d,
          nls.builtins.diagnostics.flake8,
          -- formatting --------------------------
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.black,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.isort,
        },
        -- auto-format on save -------------------
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
      }
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch       = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd          = "Neotree",                     -- lazy-load on :Neotree
    keys         = { { "<Leader>e", "<Cmd>Neotree toggle<CR>",
                       desc = "File tree" } },
    config       = function()                     -- run after plugin loads
      require("plugins.neotree")                  -- <-- your mappings file
    end,
  },

  -------------------------------------------------------------------------
  -- 5. Editing niceties ----------------------------------------------------
  -------------------------------------------------------------------------
  { "numToStr/Comment.nvim",         opts = {},                 event = "VeryLazy" },
  { "windwp/nvim-autopairs",         opts = {},                 event = "InsertEnter" },
  { "lukas-reineke/indent-blankline.nvim",  main = "ibl",       event = "BufReadPost" },
  { "folke/todo-comments.nvim",      dependencies = "nvim-lua/plenary.nvim",
                                     opts = {},                 event = "VeryLazy" },
  { "folke/trouble.nvim",            opts = {},                 cmd   = "Trouble" },

  -------------------------------------------------------------------------
  -- 6. Misc & eye candy ----------------------------------------------------
  -------------------------------------------------------------------------
  { "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "VeryLazy",
    opts  = {},
  },

}) -- ← end of Lazy-spec table


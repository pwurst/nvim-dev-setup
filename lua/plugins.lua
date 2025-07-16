-- ~/.config/nvim/lua/plugins.lua -------------------------------------------
-- Central Lazy‑managed plugin registry
-- Patrick Wurster · validated 2025‑07‑16

return require("lazy").setup({

  ---------------------------------------------------------------------------
  --  Core / utility  --------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "echasnovski/mini.nvim",
    version = false,               -- track latest commit (stable branch lags)
    config  = function()
      require("mini.icons").setup()
    end,
  },

  -- Inline graphics (Kitty / WezTerm) & Jupyter kernel client
  {
    "3rd/image.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      backend      = "kitty",
      integrations = { "cmp" },
    },
  },
  {
    "benlubas/molten-nvim",
    dependencies = "3rd/image.nvim",
    build = ":UpdateRemotePlugins",
    event = "VeryLazy",
  },

  ---------------------------------------------------------------------------
  --  File explorer / sidebar  ----------------------------------------------
  ---------------------------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd    = "NeoTree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<Cmd>NeoTree toggle filesystem left<CR>",
        desc = "Explorer"    },
      { "<leader>g", "<Cmd>NeoTree toggle git_status   left<CR>",
        desc = "Git status" },
      { "<leader>d", "<Cmd>NeoTree toggle diagnostics  left<CR>",
        desc = "Diagnostics"},
    },
    opts = {
      popup_border_style = "rounded",
      enable_diagnostics = true,
      git_status         = { enable = true },
      filesystem = {
        follow_current_file    = { enabled = true },
        use_libuv_file_watcher = false, -- SSHFS‑safe
        filtered_items         = { hide_gitignored = true },
      },
    },
  },

  ---------------------------------------------------------------------------
  --  Treesitter  ------------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build  = ":TSUpdate",
    event  = { "BufReadPre", "BufNewFile" },
    opts   = {
      ensure_installed = {
        "bash", "html", "javascript", "lua",
        "markdown", "python", "r", "vim",
      },
      highlight    = { enable = true },
      indent       = { enable = true },
      auto_install = true,
    },
  },

  ---------------------------------------------------------------------------
  --  DAP stack (Python focus)  ---------------------------------------------
  ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dp = require("dap-python")
      dp.setup(vim.fn.exepath("python3"))
      vim.keymap.set("n", "<leader>dc", dp.test_class,  { desc = "Debug class"  })
      vim.keymap.set("n", "<leader>dn", dp.test_method, { desc = "Debug method" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup({
        handlers = {
          python = function(cfg)
            cfg.adapters = {
              type    = "executable",
              command = vim.fn.exepath("python3"),
              args    = { "-m", "debugpy.adapter" },
            }
            require("mason-nvim-dap").default_setup(cfg)
          end,
        },
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap, ui = require("dap"), require("dapui")
      ui.setup({
        layouts = {
          {
            elements = { "scopes", "breakpoints", "stacks", "watches" },
            size     = 40,  -- columns
            position = "left",
          },
          {
            elements = { "repl", "console" },
            size     = 0.25, -- screen height fraction
            position = "bottom",
          },
        },
        controls  = false,
        floating  = { border = "rounded" },
      })
      dap.listeners.after.event_initialized["dapui"] = ui.open
      dap.listeners.before.event_terminated["dapui"] = ui.close
      dap.listeners.before.event_exited["dapui"]      = ui.close
    end,
  },

  ---------------------------------------------------------------------------
  --  LSP, completion, formatting  ------------------------------------------
  ---------------------------------------------------------------------------
  { "williamboman/mason.nvim",           build = ":MasonUpdate",  config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = { "pyright", "ruff_lsp", "jedi_language_server" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = "hrsh7th/cmp-nvim-lsp",
  },
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
    config = function()
      require("cmp_setup")
    end,
  },

  -- none‑ls (null‑ls fork) for extra lint/format sources
  {
    "nvimtools/none-ls.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local nls = require("null-ls")
      nls.setup({
        sources = { nls.builtins.formatting.prettier },
      })
    end,
  },
  { "stevearc/conform.nvim", event = "BufWritePre" },

  ---------------------------------------------------------------------------
  --  Search / Telescope  ----------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
  },

  ---------------------------------------------------------------------------
  --  Git & VCS  -------------------------------------------------------------
  ---------------------------------------------------------------------------
  { "lewis6991/gitsigns.nvim", event = "BufReadPre" },

  ---------------------------------------------------------------------------
  --  UI / aesthetic  --------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    config   = function()
      require("catppuccin").setup({
        flavour                = "mocha",
        transparent_background = false,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "catppuccin/nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = { theme = "auto", globalstatus = true },
        sections = {
          lualine_c = { "filename", "diagnostics" },
          lualine_x = { "encoding", "filetype", "branch" },
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope  = { enabled = true, show_start = false, show_end = false },
      exclude = { filetypes = { "neo-tree", "help", "dapui_*" } },
    },
  },
  { "SmiteshP/nvim-navic", dependencies = "neovim/nvim-lspconfig", opts = { separator = "  " } },
  { "utilyre/barbecue.nvim", dependencies = { "SmiteshP/nvim-navic", "catppuccin/nvim" }, opts = { theme = "catppuccin" } },
  { "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async", opts = {
      provider_selector = function() return { "treesitter", "indent" } end,
    } },
  { "NvChad/nvim-colorizer.lua", opts = { user_default_options = { names = false } } },
  { "folke/twilight.nvim", cmd = "Twilight", opts = {} },

  ---------------------------------------------------------------------------
  --  Navigation helpers  ----------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "ThePrimeagen/harpoon",
    branch       = "harpoon2",
    dependencies = "nvim-lua/plenary.nvim",
    config       = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():append()
      end, { desc = "Harpoon add" })
      vim.keymap.set("n", "<leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon menu" })
      for i = 1, 3 do
        vim.keymap.set("n", "<leader>" .. i, function()
          harpoon:list():select(i)
        end, { desc = "Harpoon nav " .. i })
      end
    end,
  },
  {
    "stevearc/oil.nvim",
    keys = {
      { "-", function() require("oil").toggle_float() end, desc = "Oil" },
    },
    opts = {},
  },

  ---------------------------------------------------------------------------
  --  Authoring (LaTeX, Markdown, HTML/CSS/JS) -------------------------------
  ---------------------------------------------------------------------------
  {
    "lervag/vimtex",
    ft = { "tex", "latex" },
    config = function()
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_view_method     = "zathura"
    end,
  },
  { "plasticboy/vim-markdown",         ft = "markdown" },
  {
    "iamcco/markdown-preview.nvim",
    ft    = "markdown",
    build = "cd app && npm install",
    config = function() vim.g.mkdp_auto_start = 0 end,
  },
  { "mattn/emmet-vim",                 ft = { "html", "css", "javascript", "typescript" } },
  {
    "windwp/nvim-ts-autotag",
    ft           = { "html", "xml", "jsx", "tsx" },
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  ---------------------------------------------------------------------------
  --  Productivity & testing -------------------------------------------------
  ---------------------------------------------------------------------------
  { "akinsho/toggleterm.nvim",  cmd = "ToggleTerm",  opts = { size = 15 } },
  {
    "ahmedkhalf/project.nvim",
    event = "BufReadPost",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns          = { ".git", "Makefile", "pyproject.toml" },
        lsp               = { enable = false },
      })
    end,
  },
  { "nvim-neotest/nvim-nio" },
  {
    "nvim-neotest/neotest-python",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({})
        },
      })
    end,
  },

  -- Symbols / outline & navigation
  { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline" },
  { "SmiteshP/nvim-navbuddy", dependencies = "nvim-treesitter/nvim-treesitter", config = true },

  ---------------------------------------------------------------------------
  --  QoL miscellany  --------------------------------------------------------
  ---------------------------------------------------------------------------
  { "folke/which-key.nvim",     event = "VeryLazy" },
  {
  "numToStr/Comment.nvim",
  opts = {
    -- disable defaults that collide (`gc`, `gb`, etc.)
    mappings = { basic = false, extra = false },
  },
  -- explicit key‑mappings that won’t overlap
  keys = {
    { "<leader>/", mode = { "n", "v" }, desc = "Toggle comment" },
  },
},
 
  {
    "folke/trouble.nvim",
    cmd  = "Trouble",              -- new command pattern
    opts = {},
  },
  { "folke/todo-comments.nvim", event = "BufReadPost" },
})
-- end plugins.lua -----------------------------------------------------------


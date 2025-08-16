-- ~/.config/nvim/lua/lsp/servers.lua
local M = {}

function M.setup(on_attach, capabilities)
  -- IMPORTANT: require these *inside* setup(), so it runs after Lazy deps load
  local mason       = require("mason")
  local mason_lsp   = require("mason-lspconfig")
  local lspconfig   = require("lspconfig")

  local servers = {
    "pyright",
    "lua_ls",
    -- "r_language_server",
    "ts_ls",
    "marksman",
    "texlab",
    "bashls",
    "ltex",
  }

  mason.setup()

  mason_lsp.setup({
    ensure_installed       = servers,
    automatic_installation = true,
    handlers = {
      -- default handler
      function(server_name)
        lspconfig[server_name].setup({
          on_attach    = on_attach,
          capabilities = capabilities,
        })
      end,

      -- override for Lua (Neovim-aware)
      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          on_attach    = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                checkThirdParty = false,
                -- If you don't use folke/lazydev.nvim, uncomment:
                -- library = vim.api.nvim_get_runtime_file("", true),
              },
              format = { enable = false }, -- use stylua via none-ls
              telemetry = { enable = false },
              hint = { enable = true },
            },
          },
        })
      end,
    },
  })
end

return M


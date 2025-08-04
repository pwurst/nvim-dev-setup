-- ~/.config/nvim/lua/lsp/servers.lua ---------------------------------------
local mason     = require("mason")
local mason_lsp = require("mason-lspconfig")
local lspconfig = require("lspconfig")

local on_attach    = require("lsp.on_attach").on_attach
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
  "pyright",
  "lua_ls",
--  "r_language_server",
  "ts_ls",
  "marksman",
  "texlab",
  "ltex",
}

mason.setup()

mason_lsp.setup({
  ensure_installed       = servers,
  automatic_installation = true,

  setup_handlers = {
    function(server_name)
    lspconfig[server_name].setup({
      on_attach    = on_attach,
      capabilities = capabilities,
    })
    end,

    ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      on_attach    = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace   = { library = vim.api.nvim_get_runtime_file("", true) },
                           format      = { enable = false },
                             telemetry   = { enable = false },
        },
      },
    })
    end,
  },
})

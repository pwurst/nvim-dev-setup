-- ~/.config/nvim/lua/lsp/servers.lua  ─────────────────────────────────────
local lspconfig    = require("lspconfig")
local on_attach    = require("lsp.on_attach").on_attach
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local mason        = require("mason")
local mason_lsp    = require("mason-lspconfig")

-- 1. servers you want Mason to manage
local servers = {
  "pyright",   -- Python
  "lua_ls",    -- Lua
  -- add more 
}

-- 2. bootstrap Mason
mason.setup()

-- 3. one call does it all in v2
mason_lsp.setup({
  ensure_installed       = servers,
  automatic_installation = true,

  handlers = {
    -- default handler for every server in `servers`
    function(server_name)
      lspconfig[server_name].setup({
        on_attach    = on_attach,
        capabilities = capabilities,
      })
    end,

    -- per‑server override – Lua example
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        on_attach    = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry   = { enable = false },
          },
        },
      })
    end,

    -- Uncomment to tweak Pyright
    -- ["pyright"] = function()
    --   lspconfig.pyright.setup({
    --     on_attach    = on_attach,
    --     capabilities = capabilities,
    --     settings = {
    --       python = { analysis = { typeCheckingMode = "basic" } },
    --     },
    --   })
    -- end,
  },
})


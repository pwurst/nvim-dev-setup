-- ~/.config/nvim/lua/lsp/servers.lua
local M = {}

function M.setup(on_attach, capabilities)
  local has_mason, mason = pcall(require, "mason")
  if has_mason then mason.setup() end

  local has_mls, mason_lsp = pcall(require, "mason-lspconfig")
  local has_lsp, lspconfig = pcall(require, "lspconfig")
  if not has_lsp then return end

  -- Superset of desired servers (include legacy ids; we filter below)
  local desired = {
    "basedpyright", "ruff_lsp",
    "bashls",
    "jedi_language_server",
    "ltex",
    "lua_ls",
    "marksman",
    "pyright",
    "texlab",
    -- new/old pairs:
    "ruff", "ruff_lsp",
    "ts_ls", "tsserver",
  }

  -- Ask mason-lspconfig (if present) which names it recognizes, then
  -- ensure-install only those. Falls back to "best effort".
  if has_mls then
    local avail_set = {}
    if type(mason_lsp.get_available_servers) == "function" then
      for _, name in ipairs(mason_lsp.get_available_servers()) do
        avail_set[name] = true
      end
    end
    local ensure = {}
    for _, name in ipairs(desired) do
      if next(avail_set) == nil or avail_set[name] then
        table.insert(ensure, name)
      end
    end
    mason_lsp.setup({
      ensure_installed       = ensure,
      automatic_installation = true,
    })
  end

  local function setup_if_present(name, opts)
    if lspconfig[name] then
      lspconfig[name].setup(opts)
      return true
    end
    return false
  end

  local common = { on_attach = on_attach, capabilities = capabilities }

  -- Lua (Neovim-aware tuning)
  setup_if_present("lua_ls", vim.tbl_deep_extend("force", common, {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
        format = { enable = false }, -- use stylua via Conform
        telemetry = { enable = false },
        hint = { enable = true },
      },
    },
  }))

  -- Python
  setup_if_present("pyright", common)
  if not setup_if_present("ruff", common) then
    setup_if_present("ruff_lsp", common)
  end

  -- TypeScript/JavaScript
  if not setup_if_present("ts_ls", common) then
    setup_if_present("tsserver", common)
  end

  -- Other servers
  for _, name in ipairs({ "bashls", "marksman", "texlab", "ltex", "jedi_language_server" }) do
    setup_if_present(name, common)
  end
end

return M


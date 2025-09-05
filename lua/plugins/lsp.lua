return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local ok_mlc, mlc = pcall(require, "mason-lspconfig")
    if ok_mlc then
      mlc.setup({
        ensure_installed = {
          "lua_ls", "bashls", "marksman", "texlab", "basedpyright", "ruff_lsp",
        },
        automatic_installation = true,
      })
    end

    local lspconfig = require("lspconfig")
    local caps = vim.lsp.protocol.make_client_capabilities()
    local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp and cmp_nvim_lsp then
      caps = cmp_nvim_lsp.default_capabilities(caps)
    end

    lspconfig.lua_ls.setup({
      capabilities = caps,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })

    lspconfig.bashls.setup({ capabilities = caps })
    lspconfig.marksman.setup({ capabilities = caps })
    lspconfig.texlab.setup({ capabilities = caps })

    local function has_server(name)
      local ok, _ = pcall(require, "lspconfig.server_configurations." .. name)
      return ok
    end
    if has_server("basedpyright") then
      lspconfig.basedpyright.setup({ capabilities = caps })
    elseif has_server("pyright") then
      lspconfig.pyright.setup({ capabilities = caps })
    end
    if has_server("ruff_lsp") then
      lspconfig.ruff_lsp.setup({ capabilities = caps })
    end
  end,
}
return {
  {
    "neovim/nvim-lspconfig",
    -- Load early so :checkhealth can see configured servers
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
    local lspconfig = require("lspconfig")
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_lsp.default_capabilities()

    -- nvim-cmp
    cmp.setup({
      snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
              mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                                  ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                                  ["<C-Space>"] = cmp.mapping.complete(),
                                                  ["<CR>"] = cmp.mapping.confirm({ select = true }),
                                                  ["<Tab>"] = cmp.mapping(function(fb)
                                                  if cmp.visible() then cmp.select_next_item()
                                                    elseif require("luasnip").expand_or_jumpable() then require("luasnip").expand_or_jump()
                                                      else fb() end
                                                        end, { "i", "s" }),
                                                        ["<S-Tab>"] = cmp.mapping(function(fb)
                                                        if cmp.visible() then cmp.select_prev_item()
                                                          elseif require("luasnip").jumpable(-1) then require("luasnip").jump(-1)
                                                            else fb() end
                                                              end, { "i", "s" }),
              }),
              sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
                { name = "luasnip" },
              },
    })

    local on_attach = function(client, bufnr)
    local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
    end
    bufmap("n", "gd", vim.lsp.buf.definition, "LSP: goto definition")
    bufmap("n", "gr", vim.lsp.buf.references, "LSP: references")
    bufmap("n", "gI", vim.lsp.buf.implementation, "LSP: implementation")
    bufmap("n", "K",  vim.lsp.buf.hover, "LSP: hover")
    bufmap("n", "<leader>rn", vim.lsp.buf.rename, "LSP: rename")
    bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: code action")
    bufmap("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "LSP: format")
    end

    -- Lua
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })

    -- Python: Pyright (types)
    lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })

    -- Python: Ruff (lint/code actions), no hover/format to avoid dupes with Pyright/Black
    lspconfig.ruff.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      on_attach(client, bufnr)
      end,
    })

    -- LaTeX, Markdown, Web
    lspconfig.texlab.setup({ capabilities = capabilities, on_attach = on_attach })
    lspconfig.marksman.setup({ capabilities = capabilities, on_attach = on_attach })
    lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
    lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
    end,
  },
}

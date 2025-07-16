-- lua/cmp_setup.lua ---------------------------------------------------------
-- nvim‑cmp ≥ 0.11 + LuaSnip + (optional) nvim‑autopairs integration
-- with defensive loading so that a missing/failed autopairs module no
-- longer breaks the entire completion stack.
-- Patrick Wurster · hot‑fix 2025‑07‑16

-----------------------------------------------------------------------------
-- Safe module imports -------------------------------------------------------
-----------------------------------------------------------------------------
local cmp       = require("cmp")
local luasnip   = require("luasnip")

-- Attempt to load nvim‑autopairs; if not present we simply skip pairing
local has_pairs, autopairs      = pcall(require, "nvim-autopairs")
local has_cmp_pairs, cmp_apairs = pcall(require, "nvim-autopairs.completion.cmp")

-----------------------------------------------------------------------------
-- LuaSnip ------------------------------------------------------------------
-----------------------------------------------------------------------------
luasnip.config.setup({
  history = true,
  updateevents = "TextChanged,TextChangedI",
})
require("luasnip.loaders.from_vscode").lazy_load()

-----------------------------------------------------------------------------
-- nvim‑autopairs (optional) -------------------------------------------------
-----------------------------------------------------------------------------
if has_pairs then
  autopairs.setup({})
  if has_cmp_pairs then
    cmp.event:on("confirm_done", cmp_apairs.on_confirm_done())
  end
end

-----------------------------------------------------------------------------
-- nvim‑cmp core ------------------------------------------------------------
-----------------------------------------------------------------------------
vim.o.completeopt = "menu,menuone,noselect"

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = false }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip"  },
    { name = "path"     },
  }, {
    { name = "buffer"   },
  }),

  experimental = { ghost_text = true },
})

-----------------------------------------------------------------------------
-- Broadcast cmp capabilities to all installed LSP servers -----------------
-----------------------------------------------------------------------------
local caps = require("cmp_nvim_lsp").default_capabilities()

-- Provide Pyright as a safe default if you haven't configured servers in
-- lua/lsp/servers.lua . Duplicate `require(...)` calls are ignored.
require("lspconfig").pyright.setup({ capabilities = caps })
-- end cmp_setup.lua ---------------------------------------------------------


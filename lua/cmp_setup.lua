-- ~/.config/nvim/lua/cmp_setup.lua -----------------------------------------
-- nvim-cmp 0.11 + LuaSnip (guarded) + optional autopairs integration

local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then return end

-- Guarded LuaSnip; config works even if missing
local ok_snip, luasnip = pcall(require, "luasnip")
if ok_snip then
  local ok_vs, vs_loader = pcall(require, "luasnip.loaders.from_vscode")
  if ok_vs then vs_loader.lazy_load() end
end

-- Optional autopairs integration
local ok_pairs, npairs = pcall(require, "nvim-autopairs")
local ok_cmp_pairs, cmp_pairs = pcall(require, "nvim-autopairs.completion.cmp")
if ok_pairs and ok_cmp_pairs then
  npairs.setup({})
  cmp.event:on("confirm_done", cmp_pairs.on_confirm_done())
end

cmp.setup({
  preselect = cmp.PreselectMode.Item,
  completion = { completeopt = "menu,menuone,noinsert" },

  snippet = {
    expand = function(args)
      if ok_snip then luasnip.lsp_expand(args.body) end
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"]     = cmp.mapping.abort(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<C-n>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-p>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif ok_snip and luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif ok_snip and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    ok_snip and { name = "luasnip" } or nil,
    { name = "path" },
    { name = "buffer" },
  }),
})

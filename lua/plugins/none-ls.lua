-- lua/plugins/none-ls.lua
-- lua/plugins/none-ls.lua
return {
  "nvimtools/none-ls.nvim",
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local nls = require("null-ls")
    local b = nls.builtins

    -- Prefer Mason-managed tools
    require("mason-null-ls").setup({
      ensure_installed = { "ruff", "shellcheck" },
      automatic_installation = true,
    })

    local sources = {}

    -- Ruff diagnostics (if available)
    if b.diagnostics and b.diagnostics.ruff then
      table.insert(sources, b.diagnostics.ruff.with({
        diagnostics_format = "[#{c}] #{m} (#{s})",
      }))
    end

    -- Ruff formatter: name differs across versions (ruff vs ruff_format)
    if b.formatting then
      local ruff_fmt = b.formatting.ruff_format or b.formatting.ruff
      if ruff_fmt then
        table.insert(sources, ruff_fmt)
      end
    end

    -- ShellCheck diagnostics + code actions (if present)
    if b.diagnostics and b.diagnostics.shellcheck then
      table.insert(sources, b.diagnostics.shellcheck)
    end
    if b.code_actions and b.code_actions.shellcheck then
      table.insert(sources, b.code_actions.shellcheck)
    end

    nls.setup({
      sources = sources,
      update_in_insert = false,
      debounce = 150,
    })
  end,
}


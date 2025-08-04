-- diagnostic_icons.lua
local signs = {
  Error = "",  -- nf-mdi-alert
  Warn  = "",  -- nf-mdi-alert_circle_outline
  Hint  = "",  -- nf-md-lightbulb_on_outline
  Info  = "",  -- nf-oct-info
}

for type, icon in pairs(signs) do
  vim.fn.sign_define(
    "DiagnosticSign" .. type,
    { text = icon, texthl = "DiagnosticSign" .. type }
  )
  end

  vim.diagnostic.config({
    virtual_text     = false,      -- no inline clutter; use floating
    signs            = true,
    underline        = true,
    update_in_insert = false,
  })

  return signs

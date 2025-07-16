local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = alse,  -- no inline clutter
  signs        = true,
  underline    = true,
  update_in_insert = false,
})

-- Return the icons table if you need to reference it elsewhere
return icons

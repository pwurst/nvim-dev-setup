-- lua/highlight/python.lua
local ts  = vim.treesitter.highlighter.hl_map -- shorthand
local set = vim.api.nvim_set_hl

-- high-energy yellow for builtins (open, range, len …)
set(0, "@function.builtin.python", { fg = "#E5C07B", bold = true })

-- bright cyan for imports / module names
set(0, "@module.python",           { fg = "#56B6C2", italic = true })

-- muted orange for parameters (stands out from locals)
set(0, "@parameter.python",        { fg = "#D19A66" })

-- lilac for self / cls
set(0, "@variable.builtin.python", { fg = "#C678DD", italic = true })

-- diagnostic underline that doesn’t erase the text colour
set(0, "DiagnosticUnderlineError", { underline = true, sp = "#E06C75" })

-- functions
set(0, "@function.python",        { fg = "#E5C07B", italic = true })
set(0, "@function.call.python",   { italic = true })

-- types & modules
set(0, "@type.python",            { fg = "#56B6C2", italic = true })
set(0, "@namespace.python",       { fg = "#56B6C2", italic = true })

-- parameters
set(0, "@parameter.python",       { fg = "#D19A66", italic = true })

-- docstrings & comments
set(0, "@string.doc.python",      { fg = "#5C6370", italic = true })
set(0, "Comment",                 { fg = "#5C6370", italic = true })


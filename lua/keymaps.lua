-- lua/core/keymaps.lua
local map, del = vim.keymap.set, vim.keymap.del

-- robust delete: remove if present (global or buffer-local)
local function sdel(modes, lhs, opts)
  opts = opts or {}
  local ms = type(modes) == "table" and modes or { modes }
  for _, m in ipairs(ms) do
    pcall(del, m, lhs, opts)
  end
end

-- nuke known conflicting prefixes and their variants
local function nuke_conflicts(bufnr)
  local bo = bufnr and { buffer = bufnr } or nil
  -- Comment.nvim defaults
  for _, lhs in ipairs({ "gc", "gb", "gcc", "gco", "gcO", "gcA" }) do
    sdel({ "n", "x", "o" }, lhs, bo)
  end
  -- LSP-style 'gr*' groups
  for _, lhs in ipairs({ "gr", "grr", "grt", "gra", "gri", "grn" }) do
    sdel("n", lhs, bo)
  end
  -- leader prefix that collides with <leader>ff / <leader>fg
  sdel({ "n", "x" }, "<leader>f", bo)
end

-- also scrub any maps returned by API that match our list (belt & suspenders)
local function deep_scrub()
  local targets = {
    n = { "gc", "gb", "gcc", "gco", "gcO", "gcA", "gr", "grr", "grt", "gra", "gri", "grn", "<leader>f" },
    x = { "gc", "gb", "<leader>f" },
    o = { "gc", "gb" },
  }
  for mode, lhss in pairs(targets) do
    local maps = vim.api.nvim_get_keymap(mode)
    for _, lhs in ipairs(lhss) do
      for _, m in ipairs(maps) do
        if m.lhs == lhs then pcall(vim.keymap.del, mode, lhs) end
      end
    end
  end
end

-- run early and after plugins (VeryLazy), and on buffer/LSP events
nuke_conflicts()
vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", callback = function()
  nuke_conflicts()
  deep_scrub()
end })

vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = function()
  nuke_conflicts()
end })

vim.api.nvim_create_autocmd("LspAttach", { callback = function(args)
  nuke_conflicts(args.buf)
end })

-- ── your preferred mappings (conflict-free) ───────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Comment toggles on <leader>c* (requires Comment.nvim)
do
  local ok, C = pcall(require, "Comment.api")
  if ok then
    map("n", "<leader>cl", function() C.toggle.linewise.current() end, { desc = "Comment: toggle line" })
    map("x", "<leader>cl", function() C.toggle.linewise(vim.fn.visualmode()) end, { desc = "Comment: toggle lines" })

    map("n", "<leader>cb", function() C.toggle.blockwise.current() end, { desc = "Comment: toggle block" })
    map("x", "<leader>cb", function() C.toggle.blockwise(vim.fn.visualmode()) end, { desc = "Comment: toggle block sel" })

    map("n", "<leader>cA", function() C.insert.linewise.eol() end,   { desc = "Comment: at EOL" })
    map("n", "<leader>co", function() C.insert.linewise.below() end, { desc = "Comment: line below" })
    map("n", "<leader>cO", function() C.insert.linewise.above() end, { desc = "Comment: line above" })
  end
end

-- Telescope under <leader>f* (no mapping on bare <leader>f)
do
  local ok, tb = pcall(require, "telescope.builtin")
  if ok then
    map("n", "<leader>ff", tb.find_files,                     { desc = "Find files" })
    map("n", "<leader>fg", tb.live_grep,                      { desc = "Grep (ripgrep)" })
    map("n", "<leader>fb", tb.buffers,                        { desc = "Buffers" })
    map("n", "<leader>fh", tb.help_tags,                      { desc = "Help tags" })
    map("n", "<leader>fr", tb.resume,                         { desc = "Resume last picker" })
    map("n", "<leader>fs", tb.lsp_document_symbols,           { desc = "Document symbols" })
  end
end

-- LSP under <leader>l* (buffer-local on attach)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local bo = { buffer = bufnr, silent = true }
    -- ensure no stray 'gr*' on this buffer
    for _, lhs in ipairs({ "gr", "grr", "grt", "gra", "gri", "grn" }) do
      sdel("n", lhs, { buffer = bufnr })
    end
    map("n", "<leader>ld", vim.lsp.buf.definition,      vim.tbl_extend("force", bo, { desc = "LSP: definition" }))
    map("n", "<leader>lD", vim.lsp.buf.declaration,     vim.tbl_extend("force", bo, { desc = "LSP: declaration" }))
    map("n", "<leader>li", vim.lsp.buf.implementation,  vim.tbl_extend("force", bo, { desc = "LSP: implementation" }))
    map("n", "<leader>lt", vim.lsp.buf.type_definition, vim.tbl_extend("force", bo, { desc = "LSP: type def" }))
    map("n", "<leader>lr", vim.lsp.buf.references,      vim.tbl_extend("force", bo, { desc = "LSP: references" }))
    map("n", "<leader>la", vim.lsp.buf.code_action,     vim.tbl_extend("force", bo, { desc = "LSP: code action" }))
    map("n", "<leader>lR", vim.lsp.buf.rename,          vim.tbl_extend("force", bo, { desc = "LSP: rename" }))
    map("n", "<leader>lk", vim.lsp.buf.hover,           vim.tbl_extend("force", bo, { desc = "LSP: hover" }))
    map({ "n", "x" }, "<leader>lf", function() vim.lsp.buf.format({ async = true }) end,
      vim.tbl_extend("force", bo, { desc = "LSP: format" }))
  end,
})

-- Optional: Oil on '-'
pcall(map, "n", "-", "<CMD>Oil<CR>", { desc = "Oil: parent directory" })


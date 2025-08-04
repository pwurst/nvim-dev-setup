-- ~/.config/nvim/lua/keymaps.lua -------------------------------------------
-- All custom key-bindings
-- Patrick Wurster · patched 2025-08-04

local map  = vim.keymap.set
local opts = { noremap = true, silent = true }

---------------------------------------------------------------------------
-- 1. General / UI ---------------------------------------------------------
---------------------------------------------------------------------------
map("n", "<leader>qq", "<Cmd>qa!<CR>", opts)                  -- quit all
map("n", "<leader>w", "<Cmd>w<CR>", opts)                     -- quick save
map("n", "<leader>e", "<Cmd>Neotree toggle<CR>", opts)        -- file explorer
map("n", "<leader>f", "<Cmd>Telescope find_files<CR>", opts)  -- fuzzy files
-- add your usual motions…

---------------------------------------------------------------------------
-- 2. LSP helpers ----------------------------------------------------------
---------------------------------------------------------------------------
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gr", vim.lsp.buf.references, opts)
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
map("n", "<leader>rn", vim.lsp.buf.rename, opts)
map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end,
  vim.tbl_extend("force", opts, { desc = "Format buffer" }))

---------------------------------------------------------------------------
-- 3. Debug Adapter Protocol (safe load) ----------------------------------
---------------------------------------------------------------------------
local ok, dap = pcall(require, "dap")
if ok then
  map("n", "<F5>", dap.continue, opts)
  map("n", "<F10>", dap.step_over, opts)
  map("n", "<F11>", dap.step_into, opts)
  map("n", "<F12>", dap.step_out, opts)
  map("n", "<leader>b", dap.toggle_breakpoint, opts)
  map("n", "<leader>B",
    function() dap.set_breakpoint(vim.fn.input("Condition > ")) end,
    opts)
  map("n", "<leader>dr", dap.repl.open, opts)
  map("n", "<leader>dl", dap.run_last, opts)
end

---------------------------------------------------------------------------
-- EOF ---------------------------------------------------------------------

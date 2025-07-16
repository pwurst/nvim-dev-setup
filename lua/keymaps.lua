-- ~/.config/nvim/lua/keymaps.lua
local map   = vim.keymap.set
local dap   = require("dap")
local dapui = require("dapui")

---------------------------------------------------------------------------
--  Debug adapter (DAP) bindings  ─────────────────────────────────────────
---------------------------------------------------------------------------
map("n", "<F5>",  dap.continue,          { desc = "Debug: Continue / Start" })
map("n", "<F10>", dap.step_over,         { desc = "Debug: Step over" })
map("n", "<F11>", dap.step_into,         { desc = "Debug: Step into" })
map("n", "<F12>", dap.step_out,          { desc = "Debug: Step out" })
map("n", "<F9>",  dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
map("n", "<F8>",  function()
  dap.set_breakpoint(vim.fn.input("Condition > "))
end, { desc = "Debug: Conditional breakpoint" })
map("n", "<F7>", dapui.toggle,           { desc = "Debug: Toggle DAP UI" })
-- Comment toggle (works in Normal + Visual)
map({ "n", "v" }, "<leader>/",
    function() require("Comment.api").toggle.linewise.current() end,
    { desc = "Toggle comment" })
---------------------------------------------------------------------------
--  Code Runner bindings  (no overlap with comment keys)  ────────────────
---------------------------------------------------------------------------
--  NOTE: Remove the `keys = {...}` block for Code Runner in your
--  `plugins.lua` so these mappings are the only ones active.
map("n", "<leader>Rf", "<Cmd>RunFile<CR>",      { desc = "Run file" })
map("v", "<leader>Rv", "<Cmd>RunCode<CR>",      { desc = "Run selection" })
map("n", "<leader>Rp", "<Cmd>RunProject<CR>",   { desc = "Run project" })


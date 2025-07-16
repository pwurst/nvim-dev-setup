-- ~/.config/nvim/lua/dap.lua -----------------------------------------------
local dap, dapui = require("dap"), require("dapui")

---------------------------------------------------------------------------
--  1  UI layout                                                           
---------------------------------------------------------------------------
dapui.setup({
  layouts = {
    {
      elements = {          -- left sidebar
        { id = "scopes",      size = 0.30 },
        { id = "breakpoints", size = 0.20 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 0.25 },
      },
      size = 40, position = "left",
    },
    {
      elements = { "repl", "console" },   -- bottom split
      size = 0.25, position = "bottom",
    },
  },
  controls = { enabled = false },         -- toolbar off (keymaps instead)
  floating = { border = "rounded" },
})

---------------------------------------------------------------------------
--  2  Event hooks                                                         
--      open UI on session start, close on termination / exit              
---------------------------------------------------------------------------
local function open_ui()  dapui.open() end
local function close_ui() dapui.close() end

dap.listeners.after.event_initialized["dapui_config"] = open_ui
dap.listeners.before.event_terminated["dapui_config"] = close_ui
dap.listeners.before.event_exited["dapui_config"]      = close_ui

---------------------------------------------------------------------------
--  3  Python adapter & configurations                                    
---------------------------------------------------------------------------
-- Resolve interpreter robustly: inside venv if present, else system python
local function default_python()
  return vim.fn.getenv("VIRTUAL_ENV")
       and (vim.fn.getenv("VIRTUAL_ENV") .. "/bin/python")
        or "python3"
end

require("dap-python").setup(default_python(), {
  include_configs = true,    -- respect .vscode/launch.json if present
})

-- quick-launch config for the current file (F5)
dap.configurations.python = {
  {
    type          = "python",
    request       = "launch",
    name          = "⟨buffer⟩",
    program       = "${file}",
    console       = "integratedTerminal",  -- keeps stdin active
    justMyCode    = false,                 -- show libs in backtrace
    pythonPath    = default_python,
  },
}

---------------------------------------------------------------------------
--  5  Optional: auto-install debugpy via Mason                            
---------------------------------------------------------------------------
-- ensure debugpy is present on first attach (no manual venv activation)
require("mason-nvim-dap").setup({ handlers = { python = function() end } })


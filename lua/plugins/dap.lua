return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>",  function() require("dap").continue() end,          desc = "DAP: Continue" },
      { "<F10>", function() require("dap").step_over() end,         desc = "DAP: Step over" },
      { "<F11>", function() require("dap").step_into() end,         desc = "DAP: Step into" },
      { "<F12>", function() require("dap").step_out() end,          desc = "DAP: Step out" },
      { "<F9>",  function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle BP" },
    },
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.30 },
            { id = "breakpoints", size = 0.20 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "right",
        },
        { elements = { "repl", "console" }, size = 10, position = "bottom" },
      },
    },
    config = function(_, opts)
    local dapui = require("dapui")
    dapui.setup(opts)
    local dap = require("dap")
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI: Toggle" },
    },
  },

  -- Python adapter:
  -- * Adapter runs from Mason's debugpy venv (no need to install debugpy per project)
  -- * The debugged program runs with the project's own interpreter (pythonPath resolver)
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    config = function()
    local fn = vim.fn

    -- Adapter (server) Python with debugpy (managed by Mason)
    local mason_debugpy = fn.stdpath("data")
    .. "/mason/packages/debugpy/venv/bin/python"
    require("dap-python").setup(mason_debugpy)

    -- Resolve the interpreter for the *program being debugged* (per project)
    local function project_python()
    -- 1) Respect active virtualenv if set
    local venv = vim.env.VIRTUAL_ENV
    if venv and fn.executable(venv .. "/bin/python") == 1 then
      return venv .. "/bin/python"
      end
      -- 2) Project-local .venv / venv under cwd
      local cwd = fn.getcwd()
      local candidates = {
        cwd .. "/.venv/bin/python",
        cwd .. "/venv/bin/python",
      }
      for _, p in ipairs(candidates) do
        if fn.executable(p) == 1 then return p end
          end
          -- 3) pyenv (if active in this directory)
          local pyenv_path = fn.systemlist("pyenv which python")[1]
          if vim.v.shell_error == 0 and pyenv_path
            and fn.executable(pyenv_path) == 1 then
            return pyenv_path
            end
            -- 4) System fallback
            if fn.executable("/usr/bin/python3") == 1 then
              return "/usr/bin/python3"
              end
              return "python3"
              end

              -- DAP launch configurations (use per-project pythonPath)
              local dap = require("dap")
              dap.configurations.python = {
                {
                  type = "python",
                  request = "launch",
                  name = "Debug current file (project venv)",
                  program = "${file}",
                  pythonPath = project_python,
                  console = "integratedTerminal",
                  justMyCode = true,
                },
                {
                  type = "python",
                  request = "launch",
                  name = "Debug module (project venv)",
                  module = "pytest",              -- change to your module, e.g., "mypkg.cli"
                  args = { "-q" },                -- example pytest args
                  pythonPath = project_python,
                  console = "integratedTerminal",
                  justMyCode = true,
                },
              }
              end,
  },

  -- Inline virtual text for variables/scopes
  { "theHamsta/nvim-dap-virtual-text", opts = { commented = true } },
}

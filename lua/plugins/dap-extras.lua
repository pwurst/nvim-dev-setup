return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    -- Python adapter
    "mfussenegger/nvim-dap-python",
  },
  event = "VeryLazy",
  config = function()
    local ok_dap, dap = pcall(require, "dap")
    if not ok_dap then return end
    local ok_ui, dapui = pcall(require, "dapui")

    --------------------------------------------------------------------
    -- UI + virtual text
    --------------------------------------------------------------------
    if ok_ui then
      dapui.setup({})
      dap.listeners.after.event_initialized["dapui_autoopen"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_autoclose"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_autoclose"] = function()
        dapui.close()
      end
    end
    pcall(function()
      require("nvim-dap-virtual-text").setup({})
    end)

    --------------------------------------------------------------------
    -- Signs (no Nerd Font required)
    --------------------------------------------------------------------
    vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn",  linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DiagnosticHint",  linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint",            { text = "◆", texthl = "DiagnosticInfo",  linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticOk",    linehl = "CursorLine", numhl = "" })

    --------------------------------------------------------------------
    -- Helpers: close panes / stop sessions / argv cache
    --------------------------------------------------------------------
    local function close_floats()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative ~= "" then pcall(vim.api.nvim_win_close, win, true) end
      end
    end

    local function close_debug_ui()
      if ok_ui then pcall(dapui.close) end
      pcall(vim.cmd, "cclose")
      pcall(vim.cmd, "lclose")
      pcall(close_floats)
      pcall(function() require("dap.repl").close() end)
      vim.cmd("nohlsearch")
    end

    local function stop_debug(opts)
      -- graceful first
      pcall(dap.terminate,   { terminateDebuggee = true })
      pcall(dap.disconnect,  { terminateDebuggee = true })
      -- force if needed
      for _, s in pairs(dap.sessions()) do
        pcall(function() s:terminate() end)
        pcall(function() s:disconnect() end)
      end
      if opts and opts.clear_breakpoints then
        pcall(dap.clear_breakpoints)
      end
      close_debug_ui()
    end

    local last_args = {}

    local function set_args()
      local line = vim.fn.input("argv (space-separated): ")
      if #line == 0 then return end
      last_args = vim.split(vim.fn.trim(line), "%s+")
      print("DAP args set: " .. table.concat(last_args, " "))
    end

    local function run_with_args()
      if dap.session() then
        print("A debug session is already running.")
        return
      end
      local ft = vim.bo.filetype
      local cfg = nil
      for _, c in ipairs(dap.configurations[ft] or {}) do
        if c.request == "launch" then cfg = vim.deepcopy(c); break end
      end
      if not cfg then
        -- generic fallback: run current file
        cfg = {
          type = ft == "python" and "python" or "pwa-node",
          request = "launch",
          name = "Run current file (args)",
          program = "${file}",
          console = "integratedTerminal",
          justMyCode = false,
        }
      end
      cfg.args = vim.deepcopy(last_args)
      dap.run(cfg)
    end

    --------------------------------------------------------------------
    -- Python adapter + launch/attach configurations
    --------------------------------------------------------------------
    local function detect_python()
      for _, p in ipairs({ ".venv/bin/python", "venv/bin/python", "env/bin/python" }) do
        if vim.fn.executable(p) == 1 then return p end
      end
      return "python"
    end

    pcall(function()
      local py = detect_python()
      require("dap-python").setup(py)
    end)

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Python: Run current file",
        program = "${file}",
        console = "integratedTerminal",
        justMyCode = false,
      },
      {
        type = "python",
        request = "launch",
        name = "Python: Run module",
        module = "mypkg.cli",       -- ← edit to your package entry
        args = { "run", "--help" }, -- ← edit as needed
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        justMyCode = false,
      },
      {
        type = "python",
        request = "launch",
        name = "Python: Pytest file",
        module = "pytest",
        args = { "-q", "${file}" },
        console = "integratedTerminal",
        justMyCode = false,
      },
      {
        type = "python",
        request = "attach",
        name = "Python: Attach (localhost:5678)",
        connect = { host = "127.0.0.1", port = 5678 },
        justMyCode = false,
        -- pathMappings = {
        --   { localRoot = "/mnt/gpfs/project", remoteRoot = "/gpfs/project" },
        -- },
      },
    }

    --------------------------------------------------------------------
    -- Keymaps: stepping, bps, control, UI, args
    --------------------------------------------------------------------
    local function map(lhs, rhs, desc, modes)
      vim.keymap.set(modes or "n", lhs, rhs, { desc = "DAP: " .. desc, silent = true })
    end

    -- Start/continue + stepping
    map("<F5>",     dap.continue,     "Continue/Start")
    map("<F10>",    dap.step_over,    "Step Over")
    map("<F11>",    dap.step_into,    "Step Into")
    map("<S-F11>",  dap.step_out,     "Step Out")
    map("<leader>dc", dap.run_to_cursor, "Run to Cursor")
    map("<leader>dp", dap.pause,         "Pause")

    -- Breakpoints
    map("<F9>",     dap.toggle_breakpoint, "Toggle Breakpoint")
    map("<leader>db", function()
      dap.set_breakpoint(vim.fn.input("Condition: "))
    end, "Conditional Breakpoint")
    map("<leader>dL", function()
      dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, "Logpoint")
    map("<leader>dC", dap.clear_breakpoints, "Clear Breakpoints")

    -- Session control
    map("<leader>dR", dap.restart,        "Restart")
    map("<leader>dq", dap.terminate,      "Terminate (adapter)")
    map("<leader>dk", function() stop_debug({ clear_breakpoints = true }) end,
        "Kill + Close UI")

    -- UI / REPL
    if ok_ui then
      map("<leader>du", dapui.toggle,     "Toggle UI")
      map("<leader>dh", function() dapui.eval(nil, { enter = true }) end,
          "Eval (hover)")
      vim.keymap.set({ "n", "v" }, "<leader>de",
        function() dapui.eval() end,
        { desc = "DAP: Eval", silent = true })
    end
    map("<leader>dO", function() require("dap.repl").open() end, "Open REPL")
    map("<leader>dx", close_debug_ui, "Close UI panes")

    -- Run last + run with args
    map("<leader>dl", dap.run_last,       "Run Last")
    vim.api.nvim_create_user_command("DapSetArgs", set_args, {})
    vim.api.nvim_create_user_command("DapRunArgs", run_with_args, {})
    map("<leader>da", set_args,           "Set argv")
    map("<leader>dr", run_with_args,      "Run with argv")

    -- Safety: tidy on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function() pcall(stop_debug, { clear_breakpoints = false }) end,
    })
  end,
}


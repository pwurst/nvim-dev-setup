-- lua/config/providers.lua
local cfg = vim.fn.stdpath("config")
local python_venv = cfg .. "/.pyenvs/nvim/bin/python3"

-- Check if the specific venv exists before enforcing it
if vim.fn.executable(python_venv) == 1 then
	vim.g.python3_host_prog = python_venv
else
	-- Fallback or optional warning
	-- vim.notify("Custom Python provider not found at: " .. python_venv, vim.log.levels.WARN)
end

-- Disable unused providers for startup speed
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

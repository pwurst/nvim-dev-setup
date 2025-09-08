-- Always resolve relative to your config directory:
local cfg = vim.fn.stdpath("config")

vim.g.python3_host_prog = cfg .. "/.pyenvs/nvim/bin/python3"
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

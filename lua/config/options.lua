local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.signcolumn = "yes"
opt.termguicolors = true
opt.cursorline = true

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

opt.list = true
opt.listchars = { tab = "»·", trail = "·", extends = "…", precedes = "…", nbsp = "␣" }

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.clipboard = "unnamedplus"
opt.scrolloff = 4
opt.updatetime = 250
opt.timeoutlen = 400

opt.splitright = true
opt.splitbelow = true

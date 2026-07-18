local opt = vim.opt

-- Line Numbers
opt.number = true
opt.relativenumber = false -- Set to true if you want relative numbers (great for jumps)

-- Tabs & Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Visuals
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8 -- Keep 8 lines context when scrolling
opt.sidescrolloff = 8
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " " } -- Hide ~ on empty lines

-- Behavior
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undofile = true -- ⚡ KEY: Persistent undo history even after closing nvim
opt.updatetime = 50 -- Faster completion trigger
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.confirm = true -- Confirm to save changes before exiting modified buffer

-- Formatting
opt.textwidth = 80
opt.formatoptions = "jcroqln" -- dropped 't': auto-wrap comments only, never code lines

-- Clipboard
opt.clipboard = "unnamedplus"

opt.smoothscroll = true
opt.jumpoptions = "view" -- Ctrl+O/I restores scroll position when jumping

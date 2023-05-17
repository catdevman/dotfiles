local v = vim
v.opt.number = true
v.opt.relativenumber = true

v.opt.tabstop = 4
v.opt.softtabstop = 4
v.opt.shiftwidth = 4
v.opt.expandtab = true

v.opt.smartindent = true

v.opt.wrap = false

v.opt.swapfile = false
v.opt.backup = false
v.opt.undodir = os.getenv("HOME") .. "/.v/undodir"
v.opt.undofile = true

v.opt.hlsearch = true
v.opt.incsearch = true

v.opt.termguicolors = true

v.opt.scrolloff = 8
v.opt.signcolumn = "yes"

v.opt.updatetime = 50
v.opt.colorcolumn = "80"

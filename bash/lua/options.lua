local indent = 2

vim.cmd.colorscheme("gruvbox-material")

vim.opt.autoindent = false
vim.opt.background = "dark"
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.hidden = true
vim.opt.expandtab = true
vim.opt.mouse = nil
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.softtabstop = indent
vim.opt.tabstop = indent
vim.opt.termguicolors = true

vim.g.completion_enable_auto_popup = 0
vim.g.mapleader = ";"
vim.g.python_recommended_style = 0
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.gruvbox_material_foreground = "mix"

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

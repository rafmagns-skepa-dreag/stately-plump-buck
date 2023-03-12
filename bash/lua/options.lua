local indent = 2

vim.cmd.colorscheme('gruvbox')

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
vim.g.python3_host_prog = "/opt/rh/rh-python38/root/bin/python3"

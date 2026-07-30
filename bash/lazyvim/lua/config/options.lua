-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local indent = 4
vim.opt.mouse = nil
vim.opt.softtabstop = indent
vim.opt.tabstop = indent
vim.opt.relativenumber = false

vim.g.lazyvim_python_lsp = "ruff"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.copilot_node_command = vim.fn.expand("$HOME") .. ".asdf/shims/node"

local lspinstall = require'lspinstall'
local fns = require'lspconfig_fns'

fns.setup_servers()

lspinstall.post_install_hook = function ()
    fns.setup_servers()
    vim.cmd("bufdo e")
end
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

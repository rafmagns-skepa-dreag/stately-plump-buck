vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python" },
        callback = function(event)
                vim.opt.tabstop = 2
                vim.opt.softtabstop = 2
                vim.opt.shiftwidth = 2
        end,
})

vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*" },
        command = "if &buftype == 'terminal' | :startinsert | endif",
})

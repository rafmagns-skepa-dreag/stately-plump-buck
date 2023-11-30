local keymap = vim.keymap.set

keymap("t", "<Esc>", "<C-\\><C-n>")
-- in terminal, escape then quit
keymap("t", "<C-x>", "<C-\\><C-n><C-w>q")

-- keymap("i", ";;", "<Esc>")

keymap("n", "<Leader>n", ":set number! number? <CR>")
keymap("n", "<Leader>j", "<C-w><C-j>")
keymap("n", "<Leader>k", "<C-w><C-k>")
keymap("n", "<Leader>l", "<C-w><C-l>")
keymap("n", "<Leader>h", "<C-w><C-h>")

keymap("n", "<Leader>tt", ":terminal<CR>")
keymap("n", "<Leader>tv", ":vnew<CR>:terminal<CR>")
keymap("n", "<Leader>th", ":new<CR>:terminal<CR>")

-- toggle buffer (switch between current and last
keymap("n", "<Leader>bb", "<C-^>")

keymap("n", "<Leader>bn", ":bn<CR>")
keymap("n", "<C-l>", ":bn<CR>")
keymap("n", "<Leader>bp", ":bp<CR>")
keymap("n", "<C-h>", ":bp<CR>")

-- close buffer
keymap("n", "<Leader>bd", ":bd<CR>")
-- kill buffer
keymap("n", "<Leader>bk", ":bd!<CR>")
-- list buffer
keymap("n", "<Leader>bl", ":ls<CR>")
-- list and select buffer
keymap("n", "<Leader>bg", ":ls<CR>:buffer<Space>")

-- Use tab/shift-tab to navigate through popup menu
keymap("i", "<Tab>", "pumvisible() ? '<C-n>': '<Tab>'", { expr = true })
keymap("i", "<S-Tab>", "pumvisible() ? '<C-p>': '<S-Tab>'", { expr = true })

-- Completion
keymap("i", "<Leader><Tab>", "<Plug>(completion_smart_tab)")
keymap("i", "<Leader><S-Tab>", "<Plug>(compltion_smart_s_tab)")

-- LSP
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
keymap("n", "ge", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
keymap("n", "<Leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>")
keymap("x", "<Leader>a", "<cmd>lua vim.slp.buf.range_code_action()<CR>")

-- better indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

local builtin = require("telescope.builtin")
keymap("n", "<leader>ff", builtin.find_files, {})
keymap("n", "<leader>fg", builtin.live_grep, {})
keymap("n", "<leader>fb", builtin.buffers, {})
keymap("n", "<leader>fh", builtin.help_tags, {})

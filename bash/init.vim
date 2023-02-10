let g:loaded_python_provider = 0
let g:python3_host_prog="/usr/bin/python3"  " may need updating

luafile ~/.config/nvim/plugins.lua
luafile ~/.config/nvim/lua/lspconfig_completion.lua

" Plug 'janko-m/vim-test'

set mouse=
set termguicolors
tnoremap <Esc> <C-\><C-n>
inoremap ;; <Esc>
colo gruvbox
set background=dark
set expandtab
set tabstop=4
set softtabstop=4
set number
" set shiftwidth=0
set noautoindent
let mapleader=";"
nnoremap <silent> <leader>n :set number! number?<CR>
nnoremap <silent> <Leader>j <C-w><C-j>
nnoremap <silent> <Leader>k <C-w><C-k>
nnoremap <silent> <Leader>l <C-w><C-l>
nnoremap <silent> <Leader>h <C-w><C-h>

" Start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
nnoremap <silent> <leader>tt :terminal<CR>
nnoremap <silent> <leader>tv :vnew<CR>:terminal<CR>
nnoremap <silent> <leader>th :new<CR>:terminal<CR>

" TODO what does this do?
tnoremap <C-x> <C-\><C-n><C-w>q

" toggle buffer (switch between current and last buffer)
nnoremap <silent> <leader>bb <C-^>

" go to next buffer
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <C-l> :bn<CR>

" go to previous buffer
nnoremap <silent> <leader>bp :bp<CR>
" https://github.com/neovim/neovim/issues/2048
nnoremap <C-h> :bp<CR>

" close buffer
nnoremap <silent> <leader>bd :bd<CR>

" kill buffer
nnoremap <silent> <leader>bk :bd!<CR>

" list buffers
nnoremap <silent> <leader>bl :ls<CR>
" list and select buffer
nnoremap <silent> <leader>bg :ls<CR>:buffer<Space>


" Required for operations modifying multiple buffers like rename.
set hidden

" Always draw the signcolumn.
set signcolumn=yes

" Use tab/shift-tab to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion exp
set completeopt=menuone,noinsert,noselect

" Avoid showing extra message when using completion
set shortmess+=c

let g:completion_enable_auto_popup = 0
imap <leader><tab> <Plug>(completion_smart_tab)
imap <leader><s-tab> <Plug>(completion_smart_s_tab)

autocmd Filetype python set tabstop=2
autocmd Filetype python set softtabstop=2
autocmd Filetype python set shiftwidth=2

let g:python_recommended_style=0

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ge    <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>f    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
xmap <silent> <leader>a <cmd>lua vim.lsp.buf.range_code_action()<CR>

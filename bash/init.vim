let g:loaded_python_provider = 0
let g:python3_host_prog="/usr/bin/python3"

" Auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

if has('nvim')

Plug 'morhetz/gruvbox', {'dir': '~/.local/share/nvim/site/colors/gruvbox'}
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" TODO investigate plugins
" Plug 'janko-m/vim-test'


endif
call plug#end()


set termguicolors
tnoremap <Esc> <C-\><C-n>
inoremap ;; <Esc>
colo gruvbox
set background=dark
set expandtab
set tabstop=4
set softtabstop=4
set number
set shiftwidth=0
set noautoindent
let g:deoplete#enable_at_startup = 1
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

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': [expand('~/.vscode/extensions/ms-python.python-*/languageServer.*/Microsoft.Python.LanguageServer')],
    \ }

" nnoremap <F5> :call LanguageClient_contextMenu()<CR>

function SetLSPShortcuts()
  nnoremap <Leader>d :call LanguageClient#textDocument_definition()<CR>
  nnoremap <Leader>r :call LanguageClient#textDocument_rename()<CR>
  nnoremap <Leader>f :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <Leader>t :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <Leader>u :call LanguageClient#textDocument_references()<CR>
  nnoremap <Leader>ae :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <Leader>c :call LanguageClient#textDocument_completion()<CR>
  nnoremap <Leader>v :call LanguageClient#textDocument_hover()<CR>
  nnoremap <Leader>s :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <Leader>m :call LanguageClient_contextMenu()<CR>
endfunction()

augroup LSP
  autocmd!
  autocmd FileType python,rust,tf call SetLSPShortcuts()
augroup END

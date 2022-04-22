local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'morhetz/gruvbox'
  use 'martinda/Jenkinsfile-vim-syntax'
  use 'junegunn/fzf'
  use {'neovim/nvim-lspconfig', branch='feat/0_7_goodies'}
  use 'williamboman/nvim-lsp-installer'
  use 'iamcco/markdown-preview.nvim'
  use 'kosayoda/nvim-lightbulb'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

--local should_profile = os.getenv("NVIM_PROFILE")
--if should_profile then
--  require("profile").instrument_autocmds()
--  if should_profile:lower():match("^start") then
--    require("profile").start("*")
--  else
--    require("profile").instrument("*")
--  end
--end
--
--local function toggle_profile()
--  local prof = require("profile")
--  if prof.is_recording() then
--    prof.stop()
--    vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
--      if filename then
--        prof.export(filename)
--        vim.notify(string.format("Wrote %s", filename))
--      end
--    end)
--  else
--    prof.start("*")
--  end
--end
--vim.keymap.set("", "<f1>", toggle_profile)


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
  --use 'martinda/Jenkinsfile-vim-syntax'
  --use 'junegunn/fzf'
  use {
          'neovim/nvim-lspconfig',
          --event = 'BufReadPre',
          wants = {'cmp-nvim-lsp', 'nvim-lsp-installer', 'lsp_signature.nvim'},
          requires = {'williamboman/nvim-lsp-installer', 'ray-x/lsp_signature.nvim'},
  }
  use 'iamcco/markdown-preview.nvim'
  --use 'kosayoda/nvim-lightbulb'
  use {
      "hrsh7th/nvim-cmp",
      --event = "InsertEnter",
      opt = false,
      wants = { "LuaSnip" },
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        -- "onsails/lspkind-nvim",
        -- "hrsh7th/cmp-calc",
        -- "f3fora/cmp-spell",
        -- "hrsh7th/cmp-emoji",
        {
          "L3MON4D3/LuaSnip",
          wants = "friendly-snippets",
        },
        "rafamadriz/friendly-snippets",
      },
      disable = false
    }
  --use 'stevearc/profile'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

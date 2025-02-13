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

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

return require("packer").startup({
	function()
		-- Packer can manage itself
		use("wbthomason/packer.nvim")
		use({
			"utilyre/barbecue.nvim",
			requires = {
				"neovim/nvim-lspconfig",
				"SmiteshP/nvim-navic",
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("barbecue").setup({})
			end,
		})

		-- :Neogit
		use({
			"NeogitOrg/neogit",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("neogit").setup({})
			end,
		})

		-- gutter marking
		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup()
			end,
		})

		-- TODO add my keymappings here
		use({
			"folke/which-key.nvim",
			config = function()
				vim.o.timeout = true
				vim.o.timeoutlen = 300
				require("which-key").setup({})
			end,
		})

		use({
			"williamboman/mason.nvim",
			-- cmd = "Mason",
			config = function()
				require("mason").setup({ PATH = "prepend" })
				local mr = require("mason-registry")
				local ensure_installed = { "stylua", "ruff-lsp" }
				for _, tool in ipairs(ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end,
		})
		use({
			"williamboman/mason-lspconfig.nvim",
			requires = { "williamboman/mason.nvim" },
		})

		use("morhetz/gruvbox")
		use({
			"neovim/nvim-lspconfig",
			--event = 'BufReadPre',
			wants = { "cmp-nvim-lsp", "lsp_signature.nvim" },
			requires = { "ray-x/lsp_signature.nvim" },
		})
		use("iamcco/markdown-preview.nvim")
		--use 'kosayoda/nvim-lightbulb'

		use({
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
				-- todo maybe ray-x/cmp-sql
			},
			disable = false,
		})

		--use 'stevearc/profile'
		use({ "nvim-telescope/telescope.nvim", tag = "0.1.1", requires = { { "nvim-lua/plenary.nvim" } } })
		use("mhartington/formatter.nvim")

		-- used for yamllint for reasons?
		use("mfussenegger/nvim-lint")

		-- for personal wiki - Zettelkasten
		use({
			"mickael-menu/zk-nvim",
			config = function()
				require("zk").setup()
			end,
		})
		use("sainnhe/gruvbox-material")

		-- TODO not currently used
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "nvim-tree/nvim-web-devicons", opt = true },
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					-- A list of parser names, or "all" (the five listed parsers should always be installed)
					ensure_installed = { "python", "javascript", "typescript", "lua", "csv", "psv", "json", "yaml" },
					auto_install = true,
				})
			end,
		})

		-- pretty quickfix
		-- TODO is this used?
		use({
			"yorickpeterse/nvim-pqf",
			config = function()
				require("pqf").setup()
			end,
		})

		-- ufo is for folding
		use({
			"kevinhwang91/nvim-ufo",
			requires = "kevinhwang91/promise-async",
			config = function()
				require("ufo").setup({
					provider_selector = function(bufnr, filetype, buftype)
						return { "treesitter", "indent" }
					end,
				})
			end,
		})
		use({ "jvirtanen/vim-hcl" })

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = { transitive_opt = false, log_level = vim.log.levels.INFO },
})

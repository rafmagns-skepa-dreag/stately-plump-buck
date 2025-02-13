return {

        {
                "williamboman/mason.nvim",
        },
        {
                "williamboman/mason-lspconfig.nvim",
        },
        {
                "neovim/nvim-lspconfig",
                dependencies = {
                        { "cmp-nvim-lsp"}, {"lsp_signature.nvim"}, {"ray-x/lsp_signature.nvim"},

                }
        },
        {
                "TimUntersberger/neogit",
                dependencies = {
                        {"nvim-lua/plenary.nvim"},}
                },
                {
                        "folke/which-key.nvim",
                        lazy=true},
        {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  opts = {
    -- configurations go here
  },
},
{
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
                { "nvim-lua/plenary.nvim",
                "williamboman/mason.nvim"}
        }
},
{"morhetz/gruvbox"},
{"nvim-telescope/telescope.nvim", dependencies = {{"nvim-lua/plenary.nvim"}}},




}

local M = {}
local util = require("lspconfig/util")

local path = util.path

-- local format_disabled_var = function()
--     return string.format("format_disabled_%s", vim.bo.filetype)
-- end

-- local format_options_var = function()
--     return string.format("format_options_%s", vim.bo.filetype)
-- end


-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)


vim.diagnostic.config({
        float = { source = "always" }
})


local function find_git_base()
        local cmd = io.popen("git rev-parse --show-toplevel")
        print(cmd)
        if not cmd then
                return nil
        end
        local p = cmd:read("a")
        print(p)
        local ret_code = cmd:close()
        if ret_code ~= 0 then
                return nil
        end
        return p
end


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format { async = true } end, bufopts)

        if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                })
        end
end


local servers = {
        pyright = {
                settings = {
                        python = {
                                analysis = {
                                        typeCheckingMode = "off",
                                        autoSearchPaths = true,
                                        useLibraryCodeForTypes = true,
                                        diagnosticMode = "workspace",
                                },
                        },
                },
                root_dir = util.root_pattern(".git"),
        },
        lua_ls = {
                settings = {
                        Lua = {
                                workspace = {
                                        checkThirdParty = false,
                                        library = {
                                                [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                                                [vim.fn.expand "$VIMRUNTIME/lua/vim/lap"] = true
                                        },
                                },
                                completion = { callSnippet = "Replace" },
                                telemetry = { enable = false },
                                hint = {
                                        enable = false,
                                },
                                runtime = {
                                        version = "LuaJIT", path = vim.split(package.path, ";")
                                },
                                diagnostics = { globals = { "vim" } },
                        },
                },
        },
        ruff_lsp = {},
}


local function lsp_attach(on_attach)
        vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                        local bufnr = args.buf
                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                        on_attach(client, bufnr)
                end,
        })
end

local function lsp_capabilities()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        return require("cmp_nvim_lsp").default_capabilities(capabilities)
end


function M.setup(_)
        require("mason-lspconfig").setup { ensure_installed = vim.tbl_keys(servers) }
        require("mason-lspconfig").setup_handlers {
                function(server)
                        local server_opts = servers[server] or {}
                        server_opts.capabilities = lsp_capabilities()
                        require("lspconfig")[server].setup(server_opts)
                end,
        }
end

require("lspconfig").ruff_lsp.setup {
        on_attach = on_attach
}

function M.get_python_path(workspace)
        -- Use activated venv
        if vim.env.VIRTUAL_ENV then
                print("using env var")
                return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
        end

        for _, pattern in ipairs({ "*", ".*" }) do
                local match = vim.fn.glob(path.join(workspace, pattern, "pyenv.cfg"))
                if match ~= "" then
                        print("using pipenv match")
                        return path.join(path.dirname(match), "bin", "python")
                end
        end

        -- Find and use virtualenv via poetry in workspace directory.
        local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
        if match ~= "" then
                local venv = vim.fn.trim(vim.fn.system("poetry --directory " .. workspace .. " env info -p"))
                print("using poetry match")
                return path.join(venv, "bin", "python")
        end

        print("using fallback")

        return exepath("python3") or exepath("python") or "python"
end

local nls = require("null-ls")
nls.setup({
        sources = {
                nls.builtins.diagnostics.ruff.with { extra_args = { "--config", "tech/refdb/pyproject.toml" } },
                nls.builtins.diagnostics.sqlfluff.with { extra_args = { "--dialect", "postgres", "--config", "/home/rhanson/bootstrap/bash/sqlfluff.cfg" }, timeout = 50000, },
                --nls.builtins.diagnostics.jsonlint,
                --nls.builtins.diagnostics.luacheck,
                --nls.builtins.diagnostics.mypy,
                nls.builtins.formatting.stylua,
                nls.builtins.formatting.sql_formatter.with { extra_args = { "--language", "postgresql" } },
                nls.builtins.formatting.yapf.with { args = { "--style", "tech/jenkins/style.yapf" }, timeout = 50000, },
                nls.builtins.formatting.buildifier,
                nls.builtins.formatting.isort,
                nls.builtins.formatting.jq,
                --nls.builtins.formatting.black,
                --nls.builtins.formatting.pg_format,
                --nls.builtins.formatting.sqlfluff.with { extra_args = { "--dialect", "postgres", "--config", "/home/rhanson/bootstrap/bash/sqlfluff.cfg" }, timeout = 50000, },
                --nls.builtins.formatting.ruff.with { extra_args = { "--config", "/home/rhanson/projects/new-fields/tech/refdb/pyproject.toml" } },
        },
        on_attach = on_attach,
        debug = true,
}
)



return M

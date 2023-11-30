local M = {}

local function dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

local util = require("lspconfig/util")

local path = util.path

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

vim.diagnostic.config({
    float = { source = "always" },
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

local function quickfix()
    vim.lsp.buf.code_action({
        filter = function(a)
            return a.isPreferred
        end,
        apply = true,
    })
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

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
    vim.keymap.set("n", "<space>qf", quickfix, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
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
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lap")] = true,
                    },
                },
                completion = { callSnippet = "Replace" },
                telemetry = { enable = false },
                hint = {
                    enable = false,
                },
                runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ";"),
                },
                diagnostics = { globals = { "vim" } },
            },
        },
    },
    ruff_lsp = { settings = { args = { "--config", "tech/refdb/pyproject.toml" } }, on_attach = on_attach },
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
    require("mason").setup()
    require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
    require("mason-lspconfig").setup_handlers({
        function(server)
            local server_opts = servers[server] or {}
            server_opts.capabilities = lsp_capabilities()
            require("lspconfig")[server].setup(server_opts)
        end,
    })
end

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

local fmt = require("formatter")
fmt.setup({
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
        lua = { require("formatter.filetypes.lua").stylua },
        json = { require("formatter.filetypes.json").jq },
        yaml = {
            function()
                local yaml_config = require("formatter.filetypes.yaml").yamlfmt()
                -- yaml_config.args = { "-in", "--conf", "/home/rhanson/.config/.yamlfmt" }
                return yaml_config
            end,
        },
        python = {
            function()
                local yapf_config = require("formatter.filetypes.python").yapf()
                yapf_config.args = { "--style", "/home/rhanson/projects/omcmono/tech/jenkins/style.yapf" }
                return yapf_config
            end,
        },
        bzl = {
            function()
                local fmt_util = require("formatter.util")
                return {
                    exe = "buildifier",
                    stdin = true,
                    args = { "-path", fmt_util.escape_path(fmt_util.get_current_buffer_file_path()) },
                }
            end,
        },
        ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
})

local lint = require("lint")
lint.linters_by_ft = {
    yaml = { "yamllint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})

return M

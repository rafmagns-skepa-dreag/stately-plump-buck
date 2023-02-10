local M = {}
local lspinstall = require'nvim-lsp-installer'
local util = require('lspconfig/util')

local path = util.path
--vim.lsp.set_log_level("debug")

--local format_disabled_var = function()
--  return string.format("foramt_disabled_%s", vim.bo.filetype)
--end

--local format_options_var = function()
--  return string.format("format_options_%s", vim.bo.filetype)
--end

local format_disabled_var = function()
    return string.format("format_disabled_%s", vim.bo.filetype)
end

local format_options_var = function()
    return string.format("format_options_%s", vim.bo.filetype)
end

local servers = {
    "pyright",
    "sumneko_lua"
}


-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end


-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).

lspinstall.on_server_ready(function(server)
    local params = {}
    params.on_attach = on_attach

    if server.name == "pyright" then
        params.before_init = function(_, config)
            config.settings.python.pythonPath = M.get_python_path(config.root_dir)
        end
        params.settings = {python =
            {venvPath = "/home/rhanson/projects/omcmono", venv=".venv",
             verbose_output = true,
             executionEnvironments = {}
            }
        }
    end

    if server.name == "sumneko_lua" then
        params.settings = {
            Lua = {
                diagnostics = {globals = {'vim'}},
                workspace = {library = {[vim.fn.expand "$VIMRUNTIME/lua"] = true, [vim.fn.expand "$VIMRUNTIME/lua/vim/lap"] = true}},
            }
        }
    end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(params)
end)

function M.get_python_path(workspace)
    -- Use activated venv
    if vim.env.VIRTUAL_ENV then
        print('using env var')
        return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end

    for _, pattern in ipairs({'*', '.*'}) do
        local match = vim.fn.glob(path.join(workspace, pattern, 'pyenv.cfg'))
        if match ~= '' then
            print('using match')
            return path.join(path.dirname(match), 'bin', 'python')
        end
    end

    print('using fallback')

    return exepath('python3') or exepath('python') or 'python'
end


--local servers = {
--        pyright = {
--                on_attach = on_attach,
--                before_init = function(_, config)
--                        config.settings.python.pythonPath = M.get_python_path(config.root_dir)
--                end,
--                settings = {
--                        python = {
--                                venvPath = "/home/rhanson/projects/omcmono", venv=".venv", verbose_output=true, executionEnvironments={}
--                        }
--                }
--        },
--        sumneko_lua = {
--                settings = {
--                        Lua = {
--                                runtime = {
--                                        version = "LuaJIT", path = vim.split(package.path, ';'),},
--                                diagnostics = { globals = {'vim'}},
--                                workspace = {libarary = {[vim.fn.expand "$VIMRUNTIME/lua"] = true, [vim.fn.expand "$VIMRUNTIME/lua/vim/lap"] = true}},
--                        }
--                }
--        }
--}



function M.setup_servers()
    for _, name in pairs(servers) do
        local server_is_found, server = lspinstall.get_server(name)

        if server_is_found and not server:is_installed() then
            print("Instaling " .. name)
            server:install()
        end

        --if server_is_found then
        --    server:on_ready(function()
        --        local opts = vim.tbl_deep_extend('force', options, servers[server.name] or {})
        --        server:setup(opts)
        --    end)

        --    if not server:is_installed() then
        --        print("Installing " .. name)
        --        server:install()
        --    end
        --end
    end
end

return M

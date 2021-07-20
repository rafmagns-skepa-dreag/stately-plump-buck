local M = {}
local lspinstall = require'lspinstall'
local lspconfig = require'lspconfig'
local completion_callback = require'completion'.on_attach
local util = require'lspconfig/util'

local path = util.path


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

function M.setup_servers()
    lspinstall.setup()
    local servers = lspinstall.installed_servers()
    for _, server in pairs(servers) do
        if server == 'pyright' then
            lspconfig[server].setup({
                before_init = function(_, config)
                    config.settings.python.pythonPath = M.get_python_path(config.root_dir)
                end;
                settings = {python = {venvPath = "/home/rhanson/omcmono", venv=".venv",
                verbose_output = true,
                executionEnvironments = {
                }

            }};
                on_attach=completion_callback;
            })
        else
            lspconfig[server].setup{on_attach=completion_callback}
        end
    end
end

return M

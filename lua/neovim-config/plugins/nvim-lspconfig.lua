local on_attach = function(client, bufnr)
    if client.name == 'ts_ls' then client.server_capabilities.documentFormattingProvider = false end
    local nmap = function(keys, func, desc)
        if desc then desc = 'LSP: ' .. desc end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('<leader>li', '<cmd>LspInfo<cr>', 'LSP info')
    nmap('<leader>lI', '<cmd>NullLsInfo<cr>', 'Null-ls info')
    nmap('<leader>ld', function() vim.diagnostic.open_float({ border = 'rounded' }) end, 'Hover diagnostics')
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config('*', {
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.lsp.config('terraformls', {
    init_options = {
        experimentalFeatures = {
            validateOnSave = false,
            prefillRequiredFields = true,
        },
    },
})

vim.lsp.config('html', {
    filetypes = { 'html', 'templ' },
})

vim.lsp.config('htmx', {
    filetypes = { 'html', 'templ' },
})

vim.lsp.config('nil_ls', {
    settings = {
        ['nil'] = {
            formatting = {
                command = { 'nixpkgs-fmt' },
            },
        },
    },
})

vim.lsp.config('tailwindcss', {
    filetypes = {
        'templ',
        'astro',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
    },
    init_options = { userLanguages = { templ = 'html' } },
})

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        },
    },
})

local function jsonnet_path(root_dir)
    local paths = {
        root_dir .. '/lib',
        root_dir .. '/vendor',
    }
    return table.concat(paths, ':')
end

vim.lsp.config('jsonnet_ls', {
    cmd = function(dispatchers, config)
        local jpath = jsonnet_path(config.root_dir)
        return vim.lsp.rpc.start(
            { 'jsonnet-language-server' },
            dispatchers,
            { cwd = config.root_dir, env = { JSONNET_PATH = jpath } }
        )
    end,
})

vim.lsp.enable('gopls')
vim.lsp.enable('html')
vim.lsp.enable('htmx')
vim.lsp.enable('jsonls')
vim.lsp.enable('jsonnet_ls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('nil_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('templ')
vim.lsp.enable('terraformls')
vim.lsp.enable('ts_ls')

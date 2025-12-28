-- Autoformat on save
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = {
        '*.tf',
        '*.tfvars',
        '*.jsonnet',
        '*.libsonnet',
        '*.lua',
        '*.rs',
        '*.go',
        '*.sh',
        '*.nix',
        '*.ts',
        '*.tsx',
        '*.json',
        '*.yaml',
        '*.yml',
        '*.md',
        '*.alloy',
        '*.odin',
    },
    command = 'lua vim.lsp.buf.format()',
})

-- templ files needs special handling since it will have multiple LSPs running
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = { '*.templ' },
    command = 'lua vim.lsp.buf.format({ filter = function(client) return client.name == "templ" end })',
})

-- Auto reload files changed outside of Neovim
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermLeave', 'TermClose' }, {
    callback = function()
        if vim.bo.buftype == '' then vim.cmd('checktime') end
    end,
})

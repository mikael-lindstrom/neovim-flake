local null_ls = require('null-ls')
local helpers = require('null-ls.helpers')

local alloy_fmt = helpers.make_builtin({
    name = 'alloy_fmt',
    meta = {
        url = 'https://grafana.com/docs/alloy/latest/reference/cli/fmt/',
        description = 'The alloy fmt command rewrites `alloy` configuration files to a canonical format and style.',
    },
    method = null_ls.methods.FORMATTING,
    filetypes = { 'alloy' },
    generator_opts = {
        command = 'alloy',
        args = { 'fmt', '-' },
        to_stdin = true,
    },
    factory = helpers.formatter_factory,
})

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.prettier,
        alloy_fmt,
    },
})

require('nvim-treesitter.configs').setup({
    ensure_installed = {},
    ignore_install = { 'all' },
    sync_install = false,
    auto_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
        },
    },
})

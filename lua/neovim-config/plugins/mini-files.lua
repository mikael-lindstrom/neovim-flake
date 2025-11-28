local files = require('mini.files')

files.setup({
    mappings = {
        close = '<Esc>',
        go_in = 'L',
        go_in_plus = 'l',
    },
})

vim.keymap.set('n', '<leader>e', function() files.open() end)

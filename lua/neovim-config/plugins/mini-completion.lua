local completion = require('mini.completion')

completion.setup({
    delay = {
        completion = 100,
        info = 100,
        signature = 50,
    },
    mappings = {
        force_twostep = '<C-Space>',
        force_fallback = '<A-Space>',
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
    },
})

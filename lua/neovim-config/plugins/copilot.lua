require('copilot').setup({
    suggestions = { enabled = false },
    panel = { enabled = false },
    filetypes = {
        yaml = true,
        markdown = true,
        help = true,
    },
})
require('copilot_cmp').setup()

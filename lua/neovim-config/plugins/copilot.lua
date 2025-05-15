require('copilot').setup({
    suggestions = { enabled = false },
    panel = { enabled = false },
    filetypes = {
        gitcommit = true,
        yaml = true,
        markdown = true,
        help = true,
    },
})
require('copilot_cmp').setup()

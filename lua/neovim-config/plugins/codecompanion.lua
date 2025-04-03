require('codecompanion').setup({
    adapters = {
        copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
                schema = {
                    model = {
                        default = 'claude-3.5-sonnet',
                    },
                    max_tokens = {
                        default = 65536,
                    },
                },
            })
        end,
    },
    display = {
        chat = {
            show_settings = true,
        },
    },
})

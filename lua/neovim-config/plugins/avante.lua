require('avante').setup({
    provider = 'copilot',
    auto_suggestions_provider = 'copilot',
    behaviour = {
        auto_suggestions = false, -- Leave autosuggest to the copilot plugin
        auto_suggestions_debounce = 500,
        auto_set_highlight_group = false,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
    },
    providers = {
        copilot = {
            endpoint = 'https://api.githubcopilot.com/',
            model = 'claude-3.5-sonnet',
            proxy = nil,
            allow_insecure = false,
            timeout = 30000,
            extra_request_body = {
                temperature = 0.1,
                max_tokens = 8192,
            },
        },
        windows = {
            width = 50, -- default % based on available width in vertical layout
            sidebar_header = {
                align = 'center',
                rounded = false,
            },
            edit = {
                start_insert = false,
            },
            ask = {
                border = 'none',
                start_insert = false,
            },
        },
    },
    mappings = {
        sidebar = {
            switch_windows = '<C-j>',
            reverse_switch_windows = '<C-k>',
        },
    },
})

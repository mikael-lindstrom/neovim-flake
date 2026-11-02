local osc_colors = require('osc-colors')

-- Keep Mini's syntax/plugin roles, sourcing the palette from the terminal.
vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('TerminalPaletteHighlights', { clear = true }),
    pattern = 'osc-colors',
    callback = function()
        local detected = osc_colors.get_palette()
        if not detected then return end

        local palette = {}
        for index = 0, 15 do
            local key = string.format('base%02X', index)
            palette[key] = detected[key]
        end
        -- OSC 10 is stored in base07; use it directly for normal text.
        palette.base05 = detected.base07
        require('mini.base16').setup({ palette = palette })
        vim.g.colors_name = 'osc-colors'
    end,
})

osc_colors.setup({ mapping = 'base16' })

-- Roasted Umber palette; Mini supplies the standard syntax and plugin roles.
vim.opt.background = 'dark'
vim.opt.termguicolors = true
require('mini.base16').setup({
    palette = {
        base00 = '#16110d',
        base01 = '#241c15',
        base02 = '#3e3225',
        base03 = '#6d5e50',
        base04 = '#bfae9d',
        base05 = '#d9c8b8',
        base06 = '#efe3d5',
        base07 = '#efe3d5',
        base08 = '#df8a6e',
        base09 = '#c98a4b',
        base0A = '#e4bb7d',
        base0B = '#afbf84',
        base0C = '#a8c3ab',
        base0D = '#a6afc0',
        base0E = '#c9a4ab',
        base0F = '#cf6f52',
    },
})

vim.api.nvim_set_hl(0, 'Visual', { fg = '#efe3d5', bg = '#3e3225' })
vim.api.nvim_set_hl(0, 'Cursor', { fg = '#16110d', bg = '#c98a4b' })
vim.api.nvim_set_hl(0, 'TermCursor', { link = 'Cursor' })

-- Refresh existing plugin hooks/separators when this file is reapplied.
vim.api.nvim_exec_autocmds('ColorScheme', { pattern = '*' })

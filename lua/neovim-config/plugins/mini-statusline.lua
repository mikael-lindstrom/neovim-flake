local statusline = require('mini.statusline')

statusline.section_filename = function() return '%f%m%r' end
statusline.section_location = function() return '%l:%v' end
statusline.section_lsp = function()
    local filetype = vim.bo.filetype
    if (filetype == '') or vim.bo.buftype ~= '' then return '' end
    local buf_client_names = {}
    for _, client in pairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
        table.insert(buf_client_names, client.name or '')
    end
    return string.format(' [%s]', table.concat(buf_client_names, ','))
end

-- Map Mini mode highlights to separators
local get_mode_highlight_separator = setmetatable({
    ['MiniStatuslineModeNormal'] = 'MiniStatuslineModeNormalSeparator',
    ['MiniStatuslineModeInsert'] = 'MiniStatuslineModeInsertSeparator',
    ['MiniStatuslineModeVisual'] = 'MiniStatuslineModeVisualSeparator',
    ['MiniStatuslineModeReplace'] = 'MiniStatuslineModeReplaceSeparator',
    ['MiniStatuslineModeCommand'] = 'MiniStatuslineModeCommandSeparator',
    ['MiniStatuslineModeOther'] = 'MiniStatuslineModeOtherSeparator',
}, {
    __index = function() return 'MiniStatuslineModeOtherSeparator' end,
})

local active = function()
    if vim.bo.filetype == 'neo-tree' then return '%#MiniStatuslineInactive#%f%m%r%=' end

    local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
    local git = statusline.section_git({ trunc_width = 40 })
    local diff = statusline.section_diff({ trunc_width = 75 })
    local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
    local lsp = statusline.section_lsp()
    local filename = statusline.section_filename()
    local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
    local location = statusline.section_location()
    local search = statusline.section_searchcount({ trunc_width = 75 })

    return statusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        '%#' .. get_mode_highlight_separator[mode_hl] .. 'Left#',
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        '%#MiniStatuslineFilenameDevinfoSeparator#',
        { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        '%#' .. get_mode_highlight_separator[mode_hl] .. 'Right#',
        { hl = mode_hl, strings = { search, location } },
    })
end

local inactive = function() return '%#MiniStatuslineInactive#%f%m%r%=' end

statusline.setup({
    content = {
        active = active,
        inactive = inactive,
    },
    use_icons = true,
    set_vim_settings = true,
})

-- Add highlights after setup() when Mini has added it's own highlights
local highlights = {
    normal = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'MiniStatuslineModeNormal', link = false }).bg),
    insert = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'MiniStatuslineModeInsert', link = false }).bg),
    visual = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'MiniStatuslineModeVisual', link = false }).bg),
    replace = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'MiniStatuslineModeReplace', link = false }).bg),
    command = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'MiniStatuslineModeCommand', link = false }).bg),
    other = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'MiniStatuslineModeOther', link = false }).bg),
    filename = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'MiniStatuslineFilename', link = false }).fg),
    fileinfo = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'MiniStatuslineFileinfo', link = false }).fg),
    devinfo = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'MiniStatuslineDevinfo', link = false }).fg),
}

vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormalSeparatorLeft', { fg = highlights.normal, bg = highlights.filename })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsertSeparatorLeft', { fg = highlights.insert, bg = highlights.filename })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisualSeparatorLeft', { fg = highlights.visual, bg = highlights.filename })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplaceSeparatorLeft', { fg = highlights.replace, bg = highlights.filename })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommandSeparatorLeft', { fg = highlights.command, bg = highlights.filename })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeOtherSeparatorLeft', { fg = highlights.other, bg = highlights.filename })

vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormalSeparatorRight', { fg = highlights.normal, bg = highlights.fileinfo })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsertSeparatorRight', { fg = highlights.insert, bg = highlights.fileinfo })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisualSeparatorRight', { fg = highlights.visual, bg = highlights.fileinfo })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplaceSeparatorRight', { fg = highlights.replace, bg = highlights.fileinfo })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommandSeparatorRight', { fg = highlights.command, bg = highlights.fileinfo })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeOtherSeparatorRight', { fg = highlights.other, bg = highlights.fileinfo })

vim.api.nvim_set_hl(0, 'MiniStatuslineFilenameDevinfoSeparator', { fg = highlights.devinfo, bg = highlights.filename })

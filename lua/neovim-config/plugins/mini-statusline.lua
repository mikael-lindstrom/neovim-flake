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

-- Run after Mini's own setup/ColorScheme hook, including when reloading a theme.
local update_separator_highlights = function()
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
    local background = function(name)
        local highlight = vim.api.nvim_get_hl(0, { name = name, link = false })
        if highlight.reverse then return highlight.fg or normal.fg end
        return highlight.bg or normal.bg
    end
    local filename = background('MiniStatuslineFilename')
    local fileinfo = background('MiniStatuslineFileinfo')
    local devinfo = background('MiniStatuslineDevinfo')
    for mode, separator in pairs(get_mode_highlight_separator) do
        local color = background(mode)
        vim.api.nvim_set_hl(0, separator .. 'Left', { bg = filename, fg = color })
        vim.api.nvim_set_hl(0, separator .. 'Right', { bg = fileinfo, fg = color })
    end
    vim.api.nvim_set_hl(0, 'MiniStatuslineFilenameDevinfoSeparator', { bg = filename, fg = devinfo })
end

update_separator_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('MiniStatuslineSeparators', { clear = true }),
    callback = update_separator_highlights,
})

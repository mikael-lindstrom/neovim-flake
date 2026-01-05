vim.treesitter.language.register('river', 'alloy')

vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
        if lang and vim.treesitter.language.add(lang) then
            vim.treesitter.start()
        end
    end,
})

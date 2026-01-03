vim.treesitter.language.register('river', 'alloy')

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'alloy' },
    callback = function() vim.treesitter.start() end,
})

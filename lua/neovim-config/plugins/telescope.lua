require('telescope').setup()

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>?', builtin.oldfiles)
vim.keymap.set('n', '<leader><space>', builtin.buffers)
vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ hidden = true }) end)
vim.keymap.set('n', '<leader>fh', builtin.help_tags)
vim.keymap.set('n', '<leader>fw', builtin.grep_string)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fd', builtin.diagnostics)
vim.keymap.set('n', '<leader>fz', builtin.current_buffer_fuzzy_find)

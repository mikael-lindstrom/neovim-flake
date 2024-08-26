require('lazy').setup({
    -- Needed since lazy doesn't actually install plugins
    performance = {
        reset_packpath = false,
        rtp = {
            reset = false,
        },
    },
    spec = {
        import = 'neovim-config/plugins',
    },
    -- Lazy create this directory even though we never need it
    root = '/tmp/lazy-tmp',
    -- This needs to be set since it otherwise looks in the home directory
    lockfile = '/tmp/lazy-lock.json',
    dev = {
        path = vim.g.lazyPluginPath,
        -- All plugins are installed through nix
        patterns = { '' },
    },
    install = {
        -- Safeguard in case we forget to install a plugin with Nix
        missing = false,
    },
})

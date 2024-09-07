{ inputs }:

rec {
  # Create a neovim configuration as a plugin
  mkConfigPlugin = { system }:
    let
      vimUtils = inputs.nixpkgs.legacyPackages.${system}.vimUtils;
    in
    vimUtils.buildVimPlugin {
      name = "neovim-config";
      src = ../.;

      postInstall = ''
        rm -rf $out/.gitignore
        rm -rf $out/.git
        rm -rf $out/README.md
        rm -rf $out/flake.lock
        rm -rf $out/flake.nix
        rm -rf $out/lib
      '';
    };

  # LSPs and formatters to install
  mkNeovimLSPs = { system }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    [
      # LSPs
      pkgs.nil
      pkgs.gopls
      pkgs.jsonnet-language-server
      pkgs.lua-language-server
      pkgs.rust-analyzer
      pkgs.terraform-ls
      pkgs.templ
      pkgs.typescript-language-server
      pkgs.htmx-lsp
      pkgs.tailwindcss-language-server
      pkgs.vscode-langservers-extracted # html, markdown, eslint, json, css

      # none-ls
      pkgs.shfmt
      pkgs.stylua

      # formatting
      pkgs.nixpkgs-fmt
      pkgs.nodePackages.prettier
    ];

  # All plugins to install
  mkNeovimPlugins = { system }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      neovimConfig = mkConfigPlugin { inherit system; };
    in
    {
      config = {
        start =
          [
            pkgs.vimPlugins.plenary-nvim
            pkgs.vimPlugins.harpoon2
            pkgs.vimPlugins.telescope-nvim
            pkgs.vimPlugins.vim-tmux-navigator
            pkgs.vimPlugins.gruvbox-nvim
            pkgs.vimPlugins.nvim-web-devicons
            pkgs.vimPlugins.nui-nvim
            pkgs.vimPlugins.neo-tree-nvim
            pkgs.vimPlugins.indent-blankline-nvim
            pkgs.vimPlugins.nvim-lspconfig
            pkgs.vimPlugins.nvim-cmp
            pkgs.vimPlugins.cmp-nvim-lsp
            pkgs.vimPlugins.cmp-buffer
            pkgs.vimPlugins.luasnip
            pkgs.vimPlugins.cmp_luasnip
            pkgs.vimPlugins.copilot-cmp
            pkgs.vimPlugins.copilot-lua
            pkgs.vimPlugins.none-ls-nvim
            pkgs.vimPlugins.mini-nvim
            pkgs.vimPlugins.nvim-treesitter.withAllGrammars
            neovimConfig
          ];
      };
    };

  # Init config which loads the config plugin
  mkNeovimInitConfig =
    ''
      lua << EOF
        require 'neovim-config.init'
      EOF
    '';

  mkNeovim = { system }:
    let
      inherit (pkgs) lib neovim;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      packages = mkNeovimPlugins { inherit system; };
      lsps = mkNeovimLSPs { inherit system; };
    in
    neovim.override {
      configure = {
        customRC = mkNeovimInitConfig;
        packages = packages;
      };
      extraMakeWrapperArgs = ''--prefix PATH : "${lib.makeBinPath lsps}"'';
      withNodeJs = true;
    };
}

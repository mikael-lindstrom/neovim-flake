{ inputs }:

rec {
  # Create a neovim configuration as a plugin
  mkConfigPlugin = { system }:
    let
      vimUtils = inputs.nixpkgs.legacyPackages.${system}.vimUtils;
    in
    vimUtils.buildVimPlugin {
      name = "neovim-config";
      src = builtins.path { path = ../.; name = "source"; };

      postInstall = ''
        rm -rf $out/.gitignore
        rm -rf $out/.git
        rm -rf $out/README.md
        rm -rf $out/flake.lock
        rm -rf $out/flake.nix
        rm -rf $out/lib
      '';

      # Do not try to autoload lua modules since it will fail
      doCheck = false;
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
      pkgs.prettier
      pkgs.grafana-alloy
    ];

  # All plugins to install
  mkNeovimPlugins = { system }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      riverGrammar = pkgs.tree-sitter.buildGrammar {
        language = "river";
        version = "eafcdc5";
        src = pkgs.fetchFromGitHub {
          owner = "grafana";
          repo = "tree-sitter-river";
          rev = "eafcdc5147f985fea120feb670f1df7babb2f79e";
          sha256 = "sha256-fhuIO++hLr5DqqwgFXgg8QGmcheTpYaYLMo7117rjyk=";
        };
      };
    in
    [
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.harpoon2
      pkgs.vimPlugins.telescope-nvim
      pkgs.vimPlugins.vim-tmux-navigator
      pkgs.vimPlugins.gruvbox-nvim
      pkgs.vimPlugins.nvim-web-devicons
      pkgs.vimPlugins.indent-blankline-nvim
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.none-ls-nvim
      pkgs.vimPlugins.mini-nvim
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (_: pkgs.vimPlugins.nvim-treesitter.allGrammars ++ [
        riverGrammar
      ]))
    ];

  # All plugins to install with config plugin
  mkNeovimPluginsWithConfig = { system }:
    let
      neovimConfig = mkConfigPlugin { inherit system; };
      basePlugins = mkNeovimPlugins { inherit system; };
    in
    {
      config = {
        start = basePlugins ++ [ neovimConfig ];
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
      packages = mkNeovimPluginsWithConfig { inherit system; };
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

  mkNeovimDevShell = { system }:
    let
      inherit (pkgs) lib neovim;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      basePlugins = mkNeovimPlugins { inherit system; };
      lsps = mkNeovimLSPs { inherit system; };
    in
    neovim.override {
      configure = {
        customRC = ''
          lua << EOF
            local lua_path = vim.fn.getcwd() .. '/lua'
            local patterns = {
              lua_path .. '/?.lua',
              lua_path .. '/?/init.lua',
            }
            package.path = table.concat(patterns, ';') .. ';' .. package.path
            require('neovim-config.init')
          EOF
        '';
        packages = {
          config = {
            start = basePlugins;
          };
        };
      };
      extraMakeWrapperArgs = ''--prefix PATH : "${lib.makeBinPath lsps}"'';
      withNodeJs = true;
    };
}

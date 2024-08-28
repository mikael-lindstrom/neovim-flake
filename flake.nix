{
  description = "Neovim flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # treesitter is currently broken in unstable: https://github.com/NixOS/nixpkgs/issues/332580
    treesitter.url = "github:NixOS/nixpkgs/19581e2ce8bc43f898ef724f8072ebf62bebb325";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        apps = {
          nvim = {
            program = "${config.packages.neovim}/bin/nvim";
            type = "app";
          };
        };
        packages.default = self.lib.mkNeovim { inherit system; };
      };
      flake = {
        lib = import ./lib { inherit inputs; };
      };
    };
}

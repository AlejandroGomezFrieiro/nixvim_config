{
  description = "A very basic flake for a rust-based development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    nixvim_config.url = "github:AlejandroGomezFrieiro/nixvim_config";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixvim_config,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        neovimModule = {
          inherit pkgs;
          module = {
            imports = [
              nixvim_config.outputs.nixosModules.${system}.nvim
            ];
            plugins.rustaceanvim.enable = true;
            plugins.rustaceanvim.autoLoad = true;
          };
        };
        neovim = nixvim_config.inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule neovimModule;
      in {
        checks = {
          default = nixvim_config.inputs.nixvim.lib.${system}.check.mkTestDerivationFromNixvimModule neovimModule;
        };
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.bashInteractive
            pkgs.just
            neovim
            pkgs.rustc
            pkgs.cargo
          ];
        };
      }
    );
}

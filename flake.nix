{
  description = "Nixvim setup";
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };
inputs.nix-github-actions.url = "github:nix-community/nix-github-actions";
  inputs.nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-utils,
    nix-github-actions,
    ...
  }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
          inherit pkgs;
          module = {
            imports = [./config];
            extraPackages = [
              pkgs.alejandra
              pkgs.nixd
            ];
          };
          extraSpecialArgs = {};
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
      in {
        checks = {
          default=nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };
        packages = {
          default = nvim;
        };
        nixosModules = {
            nvim = {
                imports = [./config];
            };
        };
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.bashInteractive
            pkgs.just
          ];
        };
      }
    );
}

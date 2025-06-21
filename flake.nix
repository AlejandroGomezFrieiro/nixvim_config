{
  description = "Nix flake for my custom Neovim configuration using Nixvim";

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
  inputs = {
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    # flake-parts.url = "github:hercules-ci/flake-parts";
    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Fix a specific commit of nixpkgs for reproducibility.
    nixpkgs.url = "github:NixOS/nixpkgs/d202f48f1249f013aa2660c6733e251c85712cbe";
  };
  # outputs = inputs @ {
  #   flake-parts,
  #   nixvim,
  #   ...
  # }:
  #   flake-parts.lib.mkFlake {inherit inputs;} ({
  #     withSystem,
  #     flake-parts-lib,
  #     moduleWithSystem,
  #     ...
  #   }: rec {
  #     imports = [
  #       ./pkg.nix
  #     ];
  #
  #     # flake.nixosModules.nixvim = moduleWithSystem (
  #     #     perSystem@{config, pkgs}:
  #     #     nixos@{...}:{
  #     #       options = {};
  #     #       config = import ./config/default.nix;
  #     # });
  #     flake.nixosModules.default = {pkgs, ...}: {
  #       imports = [./nixos-module.nix];
  #     };
  #     systems = ["x86_64-linux" "aarch64-darwin"];
  #     flake.templates = {
  #       python_uv = {
  #         path = ./templates/python_uv;
  #         description = "A basic python environment with UV";
  #       };
  #       rust = {
  #         path = ./templates/rust_environment;
  #         description = "A basic rust environment";
  #       };
  #     };
  #     perSystem = {
  #       inputs',
  #       system,
  #       pkgs,
  #       self',
  #       lib,
  #       config,
  #       ...
  #     }: {
  #       formatter = pkgs.alejandra;
  #
  #       devShells.default = pkgs.mkShell {
  #         nativeBuildInputs = [
  #           pkgs.alejandra
  #           pkgs.python311Packages.pylatexenc
  #           pkgs.vectorcode
  #           pkgs.nurl
  #         ];
  #       };
  #     };
  #   });
  outputs = inputs @ {nixpkgs, ...}: let
    lib = nixpkgs.lib;
    supportedSystems = ["x86_64-linux" "aarch64-darwin"];

    # A function to get pkgs for a specific system
    getPkgsForSystem = system: import inputs.nixpkgs {inherit system;};

    # An attribute set where keys are systems and values are their respective pkgs sets
    pkgsFor = lib.genAttrs supportedSystems getPkgsForSystem;
  in rec
  {
    checks.launch-neovim = lib.genAttrs supportedSystems (system:
      inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        module = {
          imports = [./config];
          extraPackages = [pkgsFor.${system}.vectorcode];
        };
        name = "Neovim configuration";
      });
    # Define devShells for each system
    packages = lib.genAttrs supportedSystems (
      system: let
        nixvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
          module = {
            imports = [./config];
            extraPackages = [pkgsFor.${system}.vectorcode];
          };
        };
      in {
        default = nixvim;
      }
    );
    devShells = lib.genAttrs supportedSystems (
      system: let
        pkgs = pkgsFor.${system};
      in {
        default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.alejandra
            pkgs.python311Packages.pylatexenc
            pkgs.vectorcode
            pkgs.nurl
          ];
        };
      }
    );

    # Define formatter for each system
    formatter = lib.genAttrs supportedSystems (
      system: let
        pkgs = pkgsFor.${system};
      in
        pkgs.alejandra
    );

    # Other existing outputs that were correctly placed
    nixosModules.default = {pkgs, ...}: {
      imports = [./nixos-module.nix];
    };
    templates = {
      python_uv = {
        path = ./templates/python_uv;
        description = "A basic python environment with UV";
      };
      rust = {
        path = ./templates/rust_environment;
        description = "A basic rust environment";
      };
    };
  };
}

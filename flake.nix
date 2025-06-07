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
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    flake-parts,
    nixvim,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      withSystem,
      flake-parts-lib,
      moduleWithSystem,
      ...
    }: rec {
      imports = [
        ./pkg.nix
      ];

      # flake.nixosModules.nixvim = moduleWithSystem (
      #     perSystem@{config, pkgs}:
      #     nixos@{...}:{
      #       options = {};
      #       config = import ./config/default.nix;
      # });
      flake.nixosModules.default = {pkgs, ...}: {
        imports = [./nixos-module.nix];
      };
      systems = ["x86_64-linux" "aarch64-darwin"];
      flake.templates = {
        python_uv = {
          path = ./templates/python_uv;
          description = "A basic python environment with UV";
        };
        rust = {
          path = ./templates/rust_environment;
          description = "A basic rust environment";
        };
      };
      perSystem = {
        inputs',
        system,
        pkgs,
        self',
        lib,
        ...
      }: {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.alejandra
            pkgs.python311Packages.pylatexenc
            self'.packages.nixvim
          ];
        };
      };
    });
}

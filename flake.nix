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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "systems";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    eachSystem = nixpkgs.lib.genAttrs (import inputs.systems);

    nixvim_module = {pkgs, ...}: {
      imports = [./config];
    };

    mkPkgs = system: import inputs.nixpkgs {inherit system;};
  in {
    checks = eachSystem (system: let
      pkgs = mkPkgs system;
      nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = nixvim_module;
      };
    in {
      launch-neovim = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        name = "launch-neovim";
        nvim = nvim;
      };
    });

    packages = eachSystem (system: let
      pkgs = mkPkgs system;
      nixvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = nixvim_module;
      };
    in {
      default = nixvim;
      nixvim = nixvim;
    });

    devShells = eachSystem (system: let
      pkgs = mkPkgs system;
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.alejandra
          pkgs.python311Packages.pylatexenc
          pkgs.vectorcode
          pkgs.nurl
          pkgs.docker
        ];
      };
    });

    formatter = eachSystem (system: (mkPkgs system).alejandra);

    nixosModules.default = nixvim_module;
    overlays.default = final: prev: {};

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

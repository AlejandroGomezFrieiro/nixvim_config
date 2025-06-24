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
    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";
    mcp-hub.url = "github:ravitemer/mcp-hub";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "systems";
    # Fix a specific commit of nixpkgs for reproducibility.
    nixpkgs.url = "github:NixOS/nixpkgs/d202f48f1249f013aa2660c6733e251c85712cbe";
  };

  outputs = inputs @ {nixpkgs, ...}: let
      lib = nixpkgs.lib;
      eachSystem = nixpkgs.lib.genAttrs (import inputs.systems);
      
      mcphub-nvim-overlay = eachSystem(system: final: prev: { mcphub-nvim = inputs.mcphub-nvim.packages.${system}.default; } );
      mcphub-overlay = eachSystem(system: final: prev: { mcphub = inputs.mcp-hub.packages.${system}.default; });
    in
    rec
    {
      checks.launch-neovim = eachSystem (system:
          let
            pkgs = import inputs.nixpkgs {
              inherit system;
          overlays = [ 
            (final: prev: { mcphub-nvim = inputs.mcphub-nvim.packages.${system}.default; }) 
            (final: prev: { mcphub = inputs.mcp-hub.packages.${system}.default; }) 
          ];
            };
            nixvimConfigurationSet = {
              pkgs = pkgs;
              module = { pkgs, ... }: {
                imports = [./config];
                extraPackages = [pkgs.vectorcode pkgs.mcphub-nvim pkgs.uv pkgs.mcphub];
              };
            };
          in
          inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim nixvimConfigurationSet
      );

      packages = eachSystem (system:
          let
            pkgs = import inputs.nixpkgs {
              inherit system;
          overlays = [
            (final: prev: { mcphub-nvim = inputs.mcphub-nvim.packages.${system}.default; }) 
            (final: prev: { mcphub = inputs.mcp-hub.packages.${system}.default; }) 
          ];
            };
            nixvimConfigurationSet = {
              pkgs = pkgs;
              module = { pkgs, ... }: {
                imports = [./config];
                extraPackages = [pkgs.vectorcode pkgs.mcphub-nvim pkgs.mcphub pkgs.uv pkgs.docker];
              };
            };
            nixvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule nixvimConfigurationSet;
        in
        {
          default = nixvim;
          nixvim = nixvim;
        }
      );

      devShells = eachSystem (system:
          let
            pkgs = import inputs.nixpkgs {
              inherit system;
          overlays = [
            (final: prev: { mcphub-nvim = inputs.mcphub-nvim.packages.${system}.default; }) 

            (final: prev: { mcphub = inputs.mcp-hub.packages.${system}.default; }) 
          ];
            };
        in
          {
          default = pkgs.mkShell {
            nativeBuildInputs = [
                pkgs.alejandra
                pkgs.python311Packages.pylatexenc
                pkgs.vectorcode
                pkgs.nurl
                pkgs.mcphub
                pkgs.docker
            ];
          };
        }
      );

      formatter = eachSystem (system:
          let
            pkgs = import inputs.nixpkgs {
              inherit system;
            };
          in
          pkgs.alejandra
      );
    overlays.default = {
      mcphub-nvim = mcphub-nvim-overlay;
      mcphub = mcphub-overlay;
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

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

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.flake-parts = {
    url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    nixvim,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;
      flake = {
        nixosModules.neovim = {
          config,
          pkgs,
        }: {
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
        templates = {
          rust = {
            path = ./templates/rust_environment;
            description = "Rust environment";
          };
          python_uv = {
            path = ./templates/python_uv;
            description = "Simple Python environment";
          };
        };
      };
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        nixvim' = nixvim.legacyPackages.${system};
        nvim = nixvim'.makeNixvimWithModule {
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
      in {
        devShells.default = pkgs.mkShell {
          packages = [nvim pkgs.just];
        };
        formatter = pkgs.alejandra;
        packages.nixvim = nvim;
      };
    };
}

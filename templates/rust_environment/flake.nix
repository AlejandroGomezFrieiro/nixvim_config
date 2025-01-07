{
  description = "Basic flake for working with EXA";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    nixvim_config.url = "github:AlejandroGomezFrieiro/nixvim_config";
    devenv.url = "github:cachix/devenv";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };
  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        formatter = pkgs.alejandra;
        devenv.shells.default = {
          packages = [inputs.nixvim_config.packages.${system}.nixvim pkgs.just];

          languages.rust.enable = true;

          # pre-commit = {
          #   hooks = {
          #     ruff.enable = true;
          #   };
          # };
        };
      };
    };
}

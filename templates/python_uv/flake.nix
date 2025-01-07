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
        checks = {
        };
        formatter = pkgs.alejandra;
        devenv.shells.default = let
          neovimModule = {
            inherit pkgs;
            module = {
              imports = [
                inputs.nixvim_config.outputs.nixosModules.${system}.nvim
              ];
            };
          };
          neovim = inputs.nixvim_config.inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule neovimModule;
        in {
          packages = [neovim pkgs.just];

          languages.python.package = pkgs.python311;
          languages.python.enable = true;
          languages.python.uv.enable = true;
          # languages.python.uv.sync = true;
          languages.python.venv.enable = true;

          pre-commit = {
            hooks = {
              ruff.enable = true;
            };
          };
        };
      };
    };
}

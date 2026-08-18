{
  description = "Storytelling project: outline, references, and distracting-free prose in Neovim.";

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
          packages = [
            # The creative-writing Neovim build from nixvim_config.
            inputs.nixvim_config.packages.${system}.writing
            # Export manuscript to DOCX / EPUB / PDF.
            pkgs.pandoc
            # Small task runner (see justfile).
            pkgs.just
          ];

          # Everything is markdown; no language toolchain required.
        };
      };
    };
}
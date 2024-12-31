{
  description = "A very basic flake for a rust-based development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixvim.url = "github:nix-community/nixvim";
    nixvim_config.url = "github:AlejandroGomezFrieiro/nixvim_config";
  };

  outputs = {
    self,
    nixpkgs,
    nixvim_config,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    neovim = nixvim_config.inputs.nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [
          nixvim_config.outputs.nixosModules.x86_64-linux.nvim
        ];
        plugins.rustaceanvim.enable = true;
        plugins.rustaceanvim.autoLoad = true;
      };
    };
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = [
        pkgs.bashInteractive
        pkgs.just
        neovim
        pkgs.rustc
        pkgs.cargo
      ];
    };
  };
}

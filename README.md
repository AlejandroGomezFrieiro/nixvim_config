# Nixvim Configuration Flake

This flake contains a simple neovim configuration using Nixvim. With modularity in mind, some of the thought process behind it is based on
[this post](https://juuso.dev/blogPosts/modular-neovim/modular-neovim-with-nix.html).

# Usage

To run the basic neovim configuration directly from github, you can use
```
nix run github:AlejandroGomezFrieiro/nixvim_config     
```

# Per-project configuration

The flake is built to be able to extend it for different projects, thus giving personalized neovim packages.

The simplest way to extend is to generate a nix flake, importing this one. For example, to add a development shell that contains a Rust environment and its tooling (like cargo, rustc etc) and sets up rustaceanvim to handle the rust development.

```nix

{
  description = "A very basic flake for a rust-based development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  # nixvim.url = "github:nix-community/nixvim";
    nixvim_config.url = "github:AlejandroGomezFrieiro/nixvim_config";
  };

  outputs = { self, nixpkgs, nixvim_config, ...}: 
  let
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
  in
  {
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
```

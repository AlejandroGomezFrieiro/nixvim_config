# Nixvim Configuration Flake

This flake contains a simple neovim configuration using Nixvim. With modularity in mind, some of the thought process behind it is based on
[this post](https://juuso.dev/blogPosts/modular-neovim/modular-neovim-with-nix.html).

# Usage

To run the basic neovim configuration directly from github, you can use
```
nix run github:AlejandroGomezFrieiro/nixvim_config     
```

# Per-project configuration

Provided templates:

## Python

```
nix flake init --template github:AlejandroGomezFrieiro/nixvim_config#python
```

## Rust

```
nix flake init --template github:AlejandroGomezFrieiro/nixvim_config#rust
```


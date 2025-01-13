<h1 align="center">
  <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-rainbow.svg" width="200px" height="200px" />
  <br>

  <div align="center">
   <p></p>
   <a href="https://github.com/sioodmy/dotfiles/">
      <img src="https://img.shields.io/github/repo-size/AlejandroGomezFrieiro/nixvim_config?color=ea999c&labelColor=303446">
   </a>
      <a = href="https://nixos.org">
      <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?labelColor=303446&logo=NixOS&logoColor=white&color=91D7E3">
    </a>
   <br>
</div>
</div>
</h1>

This flake contains my neovim configuration, using nixvim for reproducibility.

# Usage

For standalone usage, the default package will run my neovim configuration.
```bash
nix run github:AlejandroGomezFrieiro/nixvim_config
```
# Installation

## Non NixOS systems

```bash
nix profile install github:AlejandroGomezFrieiro/nixvim_config#nixvim
```


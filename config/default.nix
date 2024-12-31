{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./lsp.nix
    ./comments.nix
    ./nvim-tree.nix
    ./whichkey.nix
    ./telescope.nix
    ./treesitter.nix
    ./wezterm.nix
  ];
  # enable = true;
  plugins.lualine.enable = true;
  plugins.web-devicons.enable = true;
  colorschemes.catppuccin.enable = true;
  opts = {
    showmatch = true;
    ignorecase = true;
    hlsearch = true;
    title = true;
    si = true;
    smarttab = true;
    incsearch = true;
    tabstop = 4;
    softtabstop = 4;
    conceallevel = 0;
    termguicolors = true;
    number = true;
    relativenumber = true;
    autoindent = true;
    clipboard = "unnamedplus";
    cursorline = true;
    list = true;
    expandtab = true;
    shiftround = true;
  };
}

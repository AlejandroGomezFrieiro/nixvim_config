{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  globals.mapleader = " ";
  plugins.which-key = {
    enable = true;
    registrations = {
      "<leader>g" = " Git";
      "<leader>f" = " Files";
      "<leader>l" = " LSP";
      "<leader>c" = "Code";
    };
  };
}

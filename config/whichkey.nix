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
    settings.spec = [
      {
      __unkeyed-1 = "<leader>g";
      group = "Git";
      icon = " ";
      }
      {
      __unkeyed-1 = "<leader>f";
      group = "Find";
      icon = " ";
      }
      {
      __unkeyed-1 = "<leader>l";
      group = "LSP";
      icon = " ";
      }
      {
      __unkeyed-1 = "<leader>c";
      group = "Code";
      # icon = " ";
      }
      {
      __unkeyed-1 = "<leader>t";
      group = "Test";
      # icon = " ";
      }
      # "<leader>g" = " Git"
      # "<leader>f" = " Files"
      # "<leader>l" = " LSP"
      # "<leader>c" = "Code"
    ];
  };
}

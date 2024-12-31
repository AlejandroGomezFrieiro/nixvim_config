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
  };
}

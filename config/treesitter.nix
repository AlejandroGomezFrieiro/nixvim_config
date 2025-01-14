{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  plugins.treesitter = {
    enable = true;
    settings.indent = {
      enable = true;
    };
    settings.highlight.enable = true;
  };
}

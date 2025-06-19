{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  plugins.treesitter-textobjects.enable = true;
  plugins.treesitter = {
    enable = true;
    settings.indent = {
      enable = true;
    };
    settings.highlight.enable = true;
  };
}

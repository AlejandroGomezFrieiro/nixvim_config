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
    };

}

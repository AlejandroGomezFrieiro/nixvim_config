{
  config,
  lib,
  pkgs,
  ...
}: {
  plugins.nvim-autopairs = {
    enable = true;
  };
}

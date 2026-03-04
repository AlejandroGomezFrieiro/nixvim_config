{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins.opencode.enable = lib.mkDefault true;

}

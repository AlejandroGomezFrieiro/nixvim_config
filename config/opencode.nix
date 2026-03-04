{
  config,
  lib,
  ...
}: let
  cfg = config.nixvim-config;
in {
  plugins.opencode.enable = lib.mkDefault cfg.ai.enable;
}

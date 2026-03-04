{
  config,
  lib,
  ...
}: let
  cfg = config.nixvim-config;
in
  lib.mkIf cfg.remoteDev.enable {
    plugins.remote-nvim = {
      enable = true;
      settings = {
        offline_mode = {
          enabled = lib.mkDefault true;
          no_github = lib.mkDefault false;
        };
      };
    };
  }

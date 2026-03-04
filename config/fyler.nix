{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixvim-config;
in
  lib.mkIf cfg.ui.fyler.enable {
    extraPlugins = with pkgs.vimPlugins; [fyler-nvim];
    extraConfigLua = ''
      require("fyler").setup({
        integrations = {
          icon = "nvim_web_devicons",
        },
        views = {
          finder = {
            default_explorer = true,
            close_on_select = false,
            win = {
              kind = "split_left_most",
            },
          },
        },
      })
    '';
    keymaps = [
      {
        mode = "n";
        key = "<leader>n";
        action.__raw = ''
          function()
            require("fyler").toggle()
          end
        '';
        options.desc = "Toggle file tree";
      }
    ];
  }

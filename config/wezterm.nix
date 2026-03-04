{
  config,
  lib,
  ...
}: let
  cfg = config.nixvim-config;
in
  lib.mkIf cfg.wezterm.enable {
    plugins.smart-splits.enable = true;
    plugins.smart-splits.autoLoad = lib.mkDefault true;
    plugins.smart-splits.lazyLoad.enable = lib.mkDefault false;
    keymaps = [
      {
        mode = "n";
        key = "<A-h>";
        action = "<cmd>lua require('smart-splits').resize_left()<cr>";
        options.desc = "Resize left";
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<cmd>lua require('smart-splits').resize_down()<cr>";
        options.desc = "Resize down";
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<cmd>lua require('smart-splits').resize_up()<cr>";
        options.desc = "Resize up";
      }
      {
        mode = "n";
        key = "<A-l>";
        action = "<cmd>lua require('smart-splits').resize_right()<cr>";
        options.desc = "Resize right";
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<cmd>lua require('smart-splits').move_cursor_left()<cr>";
        options.desc = "Move cursor left";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<cmd>lua require('smart-splits').move_cursor_down()<cr>";
        options.desc = "Move cursor down";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<cmd>lua require('smart-splits').move_cursor_up()<cr>";
        options.desc = "Move cursor up";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<cmd>lua require('smart-splits').move_cursor_right()<cr>";
        options.desc = "Move cursor right";
      }
    ];
  }

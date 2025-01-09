{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  plugins.smart-splits.enable = true;
  keymaps = [
    {
      mode = "n";
      key = "<A-h>";
      action = "<cmd>lua require('smart-splits').resize_left()<cr>";
      options.desc = "Move left";
    }
    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>lua require('smart-splits').resize_down()<cr>";
      options.desc = "Move down";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>lua require('smart-splits').resize_up()<cr>";
      options.desc = "Move up";
    }
    {
      mode = "n";
      key = "<A-l>";
      action = "<cmd>lua require('smart-splits').resize_right()<cr>";
      options.desc = "Move right";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<cmd>lua require('smart-splits').move_cursor_left()<cr>";
      options.desc = "Move left";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<cmd>lua require('smart-splits').move_cursor_down()<cr>";
      options.desc = "Move down";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>lua require('smart-splits').move_cursor_up()<cr>";
      options.desc = "Move up";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<cmd>lua require('smart-splits').move_cursor_right()<cr>";
      options.desc = "Move right";
    }
  ];
}

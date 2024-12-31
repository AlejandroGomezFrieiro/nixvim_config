{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  plugins.telescope = {
    enable = true;
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "Find grep";
    }
  ];
}

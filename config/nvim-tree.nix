{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  plugins.oil.enable = true;
  plugins.nvim-tree = {
    enable = true;
    openOnSetupFile = true;
  };
  extraPlugins = with pkgs.vimPlugins; [
    nvim-web-devicons
  ];
  keymaps = [
    {
      mode = "n";
      key = "<leader>n";
      action = "<cmd>NvimTreeToggle<cr>";
      options.desc = "Toggle tree";
    }
  ];
}

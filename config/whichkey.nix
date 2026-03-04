{lib, ...}: {
  globals.mapleader = " ";
  plugins.which-key = {
    enable = lib.mkDefault true;
    settings.spec = lib.mkDefault [
      {
        __unkeyed-1 = "<leader>g";
        group = "Git";
        icon = " ";
      }
      {
        __unkeyed-1 = "<leader>f";
        group = "Find";
        icon = " ";
      }
      {
        __unkeyed-1 = "<leader>l";
        group = "LSP";
        icon = " ";
      }
      {
        __unkeyed-1 = "<leader>c";
        group = "Code";
      }
      {
        __unkeyed-1 = "<leader>t";
        group = "Test";
      }
    ];
  };
}

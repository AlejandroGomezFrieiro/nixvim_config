{lib, ...}: {
  plugins.treesitter = {
    enable = lib.mkDefault true;
    settings.indent.enable = lib.mkDefault true;
    settings.highlight.enable = lib.mkDefault true;
  };
}

{lib, ...}: {
  plugins.treesitter = {
    enable = lib.mkDefault true;
    settings.ensure_installed = lib.mkDefault [
      "latex"
      "markdown"
      "markdown_inline"
    ];
    settings.indent.enable = lib.mkDefault true;
    settings.highlight.enable = lib.mkDefault true;
  };
}

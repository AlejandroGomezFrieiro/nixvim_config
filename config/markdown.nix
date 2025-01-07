{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
    plugins.lsp.servers.markdown_oxide.enable = true;
    extraPlugins = with pkgs.vimPlugins; [
      markdown-nvim
    ];
    extraConfigLua = "require('markdown').setup()";
}

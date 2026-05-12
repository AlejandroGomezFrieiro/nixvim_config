{lib, pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [jupynvim];

  extraPackages = with pkgs; [
    imagemagick
  ];

  extraConfigLua = ''
    require("jupynvim").setup({
      log_level = "info",
      image_renderer = "placeholder",
      core_path = "${lib.getExe pkgs.vimPlugins.jupynvim-core}",
    })
  '';
}

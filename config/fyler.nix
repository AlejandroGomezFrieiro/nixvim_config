{
  config,
  lib,
  pkgs,
  ...
}: {
  extraPlugins = with pkgs.vimPlugins; [ fyler-nvim ];
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

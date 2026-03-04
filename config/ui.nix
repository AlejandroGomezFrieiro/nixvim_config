{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixvim-config;
in {
  plugins.image.enable = lib.mkDefault cfg.ui.image.enable;
  plugins.codesnap = {
    enable = lib.mkDefault true;
    lazyLoad = {
      enable = lib.mkDefault true;
      settings.cmd = lib.mkDefault "Codesnap";
    };
  };
  plugins.noice.enable = lib.mkDefault cfg.ui.noice.enable;

  extraPlugins = with pkgs.vimPlugins; [alpha-nvim];
  extraConfigLua = ''
       local alpha = require("alpha")
       local dashboard = require("alpha.themes.dashboard")

       -- Set header
       dashboard.section.header.val = {
     [[                                                                       ]],
    [[  ██████   █████                   █████   █████  ███                  ]],
    [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
    [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
    [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
    [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
    [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
    [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
    [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
    [[                                                                       ]],
       }

       -- Set menu
       dashboard.section.buttons.val = {
           dashboard.button( "<leader>ff", "> Find file", "<cmd>lua Snacks.picker.files()<CR>"),
           dashboard.button( "<leader>fr", "> Recent"   , "<cmd>lua Snacks.picker.recent()<CR>"),
           dashboard.button( "q", "> Quit NVIM", ":qa<CR>"),
       }
       local fortune = require("alpha.fortune")
       dashboard.section.footer.val = fortune()

       dashboard.config.opts.noautocmd = true

       vim.cmd[[autocmd User AlphaReady echo 'ready']]

       alpha.setup(dashboard.config)
  '';

  keymaps = [
    {
      key = "<leader>cs";
      action = "<cmd>Codesnap<cr>";
      options = {
        silent = true;
        desc = "Code Snap";
      };
    }
    {
      key = "<leader>h";
      action = "<cmd>Alpha<cr>";
      options = {
        silent = true;
        desc = "Home Page";
      };
    }
  ];
}

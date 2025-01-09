{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  plugins.image.enable = true;
  plugins.codesnap = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings.cmd = "Codesnap";
    };
  };
  plugins.noice = {
    enable = true;
  };
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
           -- dashboard.button( "<leader>n", "  > New file" , ":ene <BAR> startinsert <CR>"),
           dashboard.button( "<leader>ff", "  > Find file", ":Telescope find_files<CR>"),
           dashboard.button( "<leader>fr", "  > Recent"   , ":Telescope frecency<CR>"),
           dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
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

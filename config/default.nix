{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./autopairs.nix
    ./comments.nix
    ./codecompanion.nix
    ./lsp.nix
    ./nvim-tree.nix
    ./neogen.nix
    ./neotest.nix
    ./telescope.nix
    ./treesitter.nix
    ./whichkey.nix
    ./ui.nix
    ./wezterm.nix
  ];
  performance = {
    byteCompileLua = {
      enable = true;
      nvimRuntime = true;
      configs = true;
      plugins = true;
    };
  };

  # extraPlugins = [
  #  (pkgs.vimUtils.buildVimPlugin {
  #   name = "ghost-text";
  # src = pkgs.fetchFromGitHub {
  #   owner = "wallpants";
  #   repo = "ghost-text.nvim";
  #   rev = "v2.0.4";
  #   hash = "sha256-zsyB3eJpwN8+dknjRZ89RttdiC1IA2LakBfnFNudQOI=";
  #   };
  # })
  # ];
  # extraConfigLua = ''
  #   require('ghost-text').setup({
  #     autostart=true,
  #     port = 4001,
  #     log_level = nil,
  #   })
  # '';
  plugins.zen-mode = {
    enable = true;
  };
  plugins.nix.enable = true;
  plugins.todo-comments.enable = true;
  plugins.lualine.enable = true;
  plugins.lz-n.enable = true;
  plugins.web-devicons.enable = true;
  colorschemes.catppuccin.enable = true;
  opts = {
    showmatch = true;
    ignorecase = true;
    hlsearch = true;
    title = true;
    si = true;
    smarttab = true;
    smartindent = true;
    incsearch = true;
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;
    conceallevel = 0;
    termguicolors = true;
    number = true;
    relativenumber = true;
    autoindent = true;
    clipboard = "unnamedplus";
    cursorline = true;
    list = true;
    expandtab = true;
    shiftround = true;
  };
  keymaps = [
    {
      key = "<ESC>";
      mode = ["t"];
      action = "<C-\\><C-n>";
    }
    {
      key = "U";
      mode = ["n" "v"];
      action = "<cmd>redo<cr>";
    }
  ];
}

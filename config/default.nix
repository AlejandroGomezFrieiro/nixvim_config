{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  files = lib.fileset.toList (lib.fileset.difference ./. ./snippets);
  # filtered_directory = (builtins.path {filter=(name: type: !(name == "snippets")); path=./.;});
  # filtered_directory = builtins.readDir filtered_source;
  files_in_directory = n: "${./.}/${n}";
in {
  # Automatically import all other config files
  imports = builtins.filter (x: !(x == ./default.nix)) files;
  performance = {
    byteCompileLua = {
      enable = lib.mkDefault true;
      nvimRuntime = true;
      configs = true;
      plugins = true;
    };
  };

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
    enable = lib.mkDefault true;
  };
  plugins.nix.enable = lib.mkDefault true;
  plugins.todo-comments.enable = lib.mkDefault true;
  plugins.lualine.enable = lib.mkDefault true;
  plugins.lz-n.enable = lib.mkDefault true;
  plugins.web-devicons.enable = lib.mkDefault true;
  colorschemes.catppuccin.enable = lib.mkDefault true;
  opts = {
    showmatch = lib.mkDefault true;
    ignorecase = lib.mkDefault true;
    hlsearch = lib.mkDefault true;
    title = lib.mkDefault true;
    si = lib.mkDefault true;
    smarttab = lib.mkDefault true;
    smartindent = lib.mkDefault true;
    incsearch = lib.mkDefault true;
    tabstop = lib.mkDefault 2;
    shiftwidth = lib.mkDefault 2;
    softtabstop = lib.mkDefault 2;
    conceallevel = lib.mkDefault 0;
    termguicolors = lib.mkDefault true;
    number = lib.mkDefault true;
    relativenumber = lib.mkDefault true;
    autoindent = lib.mkDefault true;
    clipboard = lib.mkDefault "unnamedplus";
    cursorline = lib.mkDefault true;
    list = lib.mkDefault true;
    expandtab = lib.mkDefault true;
    shiftround = lib.mkDefault true;
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

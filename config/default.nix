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
  # enable = true;
  plugins.zen-mode = {
    enable = true;
    # lazyLoad.enable = true;
    # lazyLoad.cmd = "ZenMode";
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
      key = "U";
      mode = ["n" "v"];
      action = "<cmd>redo<cr>";
    }
  ];
}

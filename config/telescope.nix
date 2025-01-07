{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  plugins.telescope = {
    enable = true;
    lazyLoad.enable = true;
    lazyLoad.settings.cmd = "Telescope";
    settings = {
      pickers.colorscheme.enable_preview = true;
    };
  };
  keymaps = [
    {
      key = "<leader>ff";
      mode = ["n" "v"];
      action.__raw = ''function() require("telescope.builtin").find_files() end'';
      options = {
        silent = true;
        desc = "Find Files";
      };
    }
    {
      key = "<leader>fk";
      mode = ["n" "v"];
      action.__raw = ''function() require("telescope.builtin").keymaps() end'';
      options = {
        silent = true;
        desc = "Find keymaps";
      };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "Find Grep";
    }
    {
      key = "<leader>lD";
      mode = ["n" "v"];
      action.__raw = ''function() require("telescope.builtin").diagnostics() end'';
      options = {
        silent = true;
        desc = "Search diagnostics";
      };
    }
    {
      key = "<leader>gb";
      mode = ["n" "v"];
      action.__raw = ''function() require("telescope.builtin").git_branches() end'';
      options = {
        silent = true;
        desc = "Git branches";
      };
    }
    {
      key = "<leader>gt";
      mode = ["n" "v"];
      action.__raw = ''function() require("telescope.builtin").git_status() end'';
      options = {
        silent = true;
        desc = "Git status";
      };
    }
  ];
}

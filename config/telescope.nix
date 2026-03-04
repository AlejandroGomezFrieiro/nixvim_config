{
  config,
  lib,
  pkgs,
  ...
}: {
  keymaps = [
    {
      key = "<leader>ff";
      mode = ["n" "v"];
      action.__raw = ''function() Snacks.picker.files() end'';
      options = {
        silent = true;
        desc = "Find Files";
      };
    }
    {
      key = "<leader>fk";
      mode = ["n" "v"];
      action.__raw = ''function() Snacks.picker.keymaps() end'';
      options = {
        silent = true;
        desc = "Find keymaps";
      };
    }
    {
      key = "<leader>fg";
      mode = ["n" "v"];
      action.__raw = ''function() Snacks.picker.grep() end'';
      options = {
        silent = true;
        desc = "Find Grep";
      };
    }
    {
      key = "<leader>fr";
      mode = ["n" "v"];
      action.__raw = ''function() Snacks.picker.recent() end'';
      options = {
        silent = true;
        desc = "Find Recent";
      };
    }
    {
      key = "<leader>lD";
      mode = ["n" "v"];
      action.__raw = ''function() Snacks.picker.diagnostics() end'';
      options = {
        silent = true;
        desc = "Search diagnostics";
      };
    }
    {
      key = "<leader>gb";
      mode = ["n" "v"];
      action.__raw = ''function() Snacks.picker.git_branches() end'';
      options = {
        silent = true;
        desc = "Git branches";
      };
    }
    {
      key = "<leader>gt";
      mode = ["n" "v"];
      action.__raw = ''function() Snacks.picker.git_status() end'';
      options = {
        silent = true;
        desc = "Git status";
      };
    }
  ];
}

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  plugins.neotest = {
    enable = true;
    adapters.python.enable = true;
    lazyLoad.enable = true;
    #
    lazyLoad.settings = {
      cmd = "Neotest";
    #   __unkeyed-1 = "<leader>tr";
    #   __unkeyed-2 = "<leader>tt";
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>tr";
      action = ":Neotest run<CR>";
      # action.__raw = ''function() require("neotest").run.run() end'';
      options.desc = "Test Nearest";
    }
    {
      mode = "n";
      key = "<leader>tt";
      action.__raw = ''function() require("neotest").run.run(vim.fn.expand('%')) end'';
      options.desc = "Test File";
    }
  ];
}

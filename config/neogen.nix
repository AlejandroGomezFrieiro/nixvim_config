{lib, ...}: {
  plugins.neogen = {
    enable = lib.mkDefault true;
    settings.languages.python = {
      annotation_convention = lib.mkDefault "google_docstrings";
    };
  };
  keymaps = [
    {
      key = "<leader>cG";
      mode = ["n" "v"];
      action = "<cmd> Neogen class<Cr>";
      options = {
        silent = true;
        desc = "Insert class doc";
      };
    }
    {
      key = "<leader>cg";
      mode = ["n" "v"];
      action = "<cmd> Neogen func<Cr>";
      options = {
        silent = true;
        desc = "Insert func doc";
      };
    }
  ];
}

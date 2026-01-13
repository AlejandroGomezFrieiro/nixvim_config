{
  ...
}: {
  plugins.remote-nvim = {
    enable = true;
    settings = {
      offline_mode = {
        enabled = true;
        no_github = false;
      };
    };
  };
}

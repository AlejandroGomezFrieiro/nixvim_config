{
  config,
  lib,
  pkgs,
  ...
}: {
  plugins.codecompanion = {
    enable = true;

    settings = {
      adapters = {
        ollama = {
          __raw = ''
            function()
              return require("codecompanion.adapters").extend("ollama", {
                schema = {
                  model = {
                    default = "moondream:latest"
                  }
                }
              })
            end
          '';
        };
      };
    };
  };
}

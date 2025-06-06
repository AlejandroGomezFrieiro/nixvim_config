{
  config,
  lib,
  pkgs,
  ...
}: {
  plugins.render-markdown = {
    enable = true;
    settings = {
      file_types = ["markdown" "codecompanion" "quarto"];
    };
  };

  plugins.codecompanion.enable = true;

  plugins.codecompanion.settings = {
    display = {
      action_palette = {
        opts = {
          show_default_prompt_library = true;
        };
        provider = "telescope";
      };
    };
    strategies = {
      agent = {adapter = "openrouter_claude";};
      chat = {adapter = "openrouter_claude";};
      inline = {adapter = "openrouter_claude";};
    };

    adapters = {
      openrouter_claude = {
        __raw = ''
          function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url="https://openrouter.ai/api";
                api_key=os.getenv("OPENROUTER_API_KEY");
                chat_url = "/v1/chat/completions",
              };
              schema = {
                model = {
                  -- default = "deepseek/deepseek-r1-0528-qwen3-8b:free",
                  default = "deepseek/deepseek-chat-v3-0324:free",

                };

              };
            })
          end
        '';
      };
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
}

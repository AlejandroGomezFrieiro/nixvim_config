{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixvim-config;
in {
  imports = [./codecompanion/prompts ./codecompanion/adapters];

  plugins.render-markdown = {
    enable = lib.mkDefault true;
    settings = {
      file_types = lib.mkDefault ["markdown" "codecompanion" "quarto"];
    };
  };

  plugins.codecompanion.enable = lib.mkDefault cfg.ai.enable;

  plugins.codecompanion.settings = {
    opts = {
      log_level = lib.mkDefault "TRACE";
      send_code = lib.mkDefault true;
      use_default_actions = lib.mkDefault true;
      use_default_prompts = lib.mkDefault true;
    };
    display = {
      action_palette = {
        opts = {
          show_default_prompt_library = lib.mkDefault true;
        };
        provider = lib.mkDefault "snacks";
      };
    };
    strategies = {
      agent = {adapter = lib.mkDefault "copilot";};
      inline = {adapter = lib.mkDefault "copilot";};
      chat = {adapter = lib.mkDefault "copilot";};
    };
    adapters = {
      http.opts.show_presets = lib.mkDefault false;
      acp.opts.show_presets = lib.mkDefault false;
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
                  default = "deepseek/deepseek-chat-v3-0324:free",
                };
              };
            })
          end
        '';
      };
    };
  };
}

{...}: {
  plugins.codecompanion.settings.adapters.chutes_ai = {
        __raw = ''
          function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url="https://llm.chutes.ai";
                api_key=os.getenv("CHUTES_AI_API_KEY");
                chat_url = "/v1/chat/completions",
              };
              schema = {
                model = {
                  default = "deepseek-ai/DeepSeek-V3-0324",
                };
              };
            })
          end
        '';
  };
}

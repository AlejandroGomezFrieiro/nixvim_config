{
  config,
  lib,
  pkgs,
  system,
  options,
  ...
}: let
  codecompanion = pkgs.fetchFromGitHub {
    owner = "olimorris";
    repo = "codecompanion.nvim";
    rev = "e7aaef6134aa9d47e214427464867c5afc4f34fe";
    hash = "sha256-wSK7JrWkvuFtl7kFVeW2SIw9GLD0/ijsw7FGN11el1A=";
  };
  vectorcode_nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "vectorcode.nvim";
    version = "0.6.10";
    buildInputs = [pkgs.vectorcode];
    sourceRoot = "${src.name}/plugin";
    dependencies = [pkgs.vimPlugins.plenary-nvim];
    src = pkgs.vectorcode.src;
    postPatch = ''
      cp -r ../lua .
    '';
  };
in rec {
  imports = [./codecompanion/prompts ./codecompanion/adapters];

  extraPlugins = [vectorcode_nvim];
  extraConfigLua = ''
    require("vectorcode").setup({})
  '';
  plugins.render-markdown = {
    enable = lib.mkDefault true;
    settings = {
      file_types = lib.mkDefault ["markdown" "codecompanion" "quarto"];
    };
  };
  plugins.codecompanion.enable = true;
  plugins.codecompanion.package = codecompanion;

  plugins.codecompanion.settings = {
    extensions = {
      vectorcode = {
        opts = {
          add_tool = lib.mkDefault true;
          add_slash_command = lib.mkDefault true;
        };
      };
    };
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
        provider = lib.mkDefault "telescope";
      };
    };
    strategies = {
      agent = {adapter = lib.mkDefault "gemini";};
      inline = {adapter = lib.mkDefault "gemini";};
      chat = {
        adapter = lib.mkDefault "gemini";
      };
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
    };
  };
}

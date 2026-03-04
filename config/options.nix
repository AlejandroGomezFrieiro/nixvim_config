# Central options namespace for nixvim-config.
#
# Downstream flakes import nixosModules.default and can override any of these
# options without needing lib.mkForce. Example downstream usage:
#
#   {
#     imports = [ inputs.nixvim_config.nixosModules.default ];
#
#     # Disable features not needed in this context
#     nixvim-config.ai.enable = false;
#     nixvim-config.remoteDev.enable = false;
#
#     # Add extra snippet directories
#     nixvim-config.lsp.extraSnippetPaths = [ ./snippets ];
#
#     # Extend codecompanion adapters (merged with the base set automatically)
#     plugins.codecompanion.settings.adapters.my_adapter = {
#       __raw = ''
#         function()
#           return require("codecompanion.adapters").extend("openai_compatible", { ... })
#         end
#       '';
#     };
#
#     # Extend or override codecompanion prompts (merged with the base set)
#     plugins.codecompanion.settings.prompt_library."My Custom Prompt" = { ... };
#   }
{lib, ...}: {
  options.nixvim-config = {
    # ---------------------------------------------------------------------------
    # AI tools: codecompanion + opencode
    # Set to false to disable all AI-related plugins in downstream configs.
    # ---------------------------------------------------------------------------
    ai.enable = lib.mkEnableOption "AI coding tools (codecompanion, opencode)" // {default = true;};

    # ---------------------------------------------------------------------------
    # Remote development via remote-nvim
    # Useful to disable in personal configs that don't need SSH-based editing.
    # ---------------------------------------------------------------------------
    remoteDev.enable = lib.mkEnableOption "remote development via remote-nvim" // {default = true;};

    # ---------------------------------------------------------------------------
    # WezTerm integration via smart-splits
    # Disable if using a different terminal multiplexer.
    # ---------------------------------------------------------------------------
    wezterm.enable = lib.mkEnableOption "WezTerm/smart-splits integration" // {default = true;};

    ui = {
      # -------------------------------------------------------------------------
      # noice.nvim: replaces the command-line and notification UI
      # -------------------------------------------------------------------------
      noice.enable = lib.mkEnableOption "noice.nvim command-line UI" // {default = true;};

      # -------------------------------------------------------------------------
      # image.nvim: inline image rendering in the terminal
      # -------------------------------------------------------------------------
      image.enable = lib.mkEnableOption "image.nvim inline image rendering" // {default = true;};

      # -------------------------------------------------------------------------
      # fyler: file tree sidebar
      # -------------------------------------------------------------------------
      fyler.enable = lib.mkEnableOption "fyler file tree" // {default = true;};
    };

    lsp = {
      # -------------------------------------------------------------------------
      # Extra LuaSnip snippet directories added on top of the built-in ones.
      # Each entry should be a path to a directory containing .lua snippet files.
      # Example: nixvim-config.lsp.extraSnippetPaths = [ ./my-snippets ];
      # -------------------------------------------------------------------------
      extraSnippetPaths = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
        description = ''
          Additional LuaSnip snippet directories to load alongside the
          built-in snippets. These are appended to the base snippet path list,
          so built-in snippets are always preserved.
        '';
        example = lib.literalExpression "[ ./work-snippets ./python-snippets ]";
      };
    };
  };
}

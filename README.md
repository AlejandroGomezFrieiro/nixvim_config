<h1 align="center">
  <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-rainbow.svg" width="200px" height="200px" />
  <br>

  <div align="center">
   <p></p>
   <a href="https://github.com/sioodmy/dotfiles/">
      <img src="https://img.shields.io/github/repo-size/AlejandroGomezFrieiro/nixvim_config?color=ea999c&labelColor=303446">
   </a>
      <a = href="https://nixos.org">
      <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?labelColor=303446&logo=NixOS&logoColor=white&color=91D7E3">
    </a>
   <br>
</div>
</div>
</h1>

This flake contains my neovim configuration, using nixvim for reproducibility.

# Usage

For standalone usage, the default package will run my neovim configuration.
```bash
nix run github:AlejandroGomezFrieiro/nixvim_config
```

# Installation

## Non NixOS systems

```bash
nix profile install github:AlejandroGomezFrieiro/nixvim_config#nixvim
```

# Using as a base in your own flake

This flake is designed to be imported as a base and extended. The
`nixosModules.default` export exposes the full configuration through the NixOS
module system, so any setting can be overridden from your downstream flake
without touching this repo.

## Minimal downstream flake

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim_config.url = "github:AlejandroGomezFrieiro/nixvim_config";
    nixvim_config.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixvim, nixvim_config, ... }: let
    system = "x86_64-linux";
    pkgs   = import nixpkgs { inherit system; };
    nvim   = nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ nixvim_config.nixosModules.default ];
        # your overrides go here
      };
    };
  in {
    packages.${system}.default = nvim;
  };
}
```

## Feature flags (`nixvim-config.*`)

All major features default to `true` and can be turned off with a plain
assignment — no `lib.mkForce` required.

| Option | Default | Controls |
|---|---|---|
| `nixvim-config.ai.enable` | `true` | codecompanion + opencode |
| `nixvim-config.remoteDev.enable` | `true` | remote-nvim |
| `nixvim-config.wezterm.enable` | `true` | smart-splits / WezTerm keymaps |
| `nixvim-config.ui.noice.enable` | `true` | noice.nvim command-line UI |
| `nixvim-config.ui.image.enable` | `true` | image.nvim inline images |
| `nixvim-config.ui.fyler.enable` | `true` | fyler file tree |

Example — a config that disables WezTerm and remote-dev:

```nix
imports = [ nixvim_config.nixosModules.default ];

nixvim-config.wezterm.enable   = false;
nixvim-config.remoteDev.enable = false;
```

## Overriding any nixvim option

Every setting in this config uses `lib.mkDefault`, so a plain assignment in
your module wins automatically:

```nix
imports = [ nixvim_config.nixosModules.default ];

# Switch the default colorscheme
colorschemes.catppuccin.enable  = false;
colorschemes.gruvbox.enable     = true;

# Change the default LSP adapter for codecompanion
plugins.codecompanion.settings.strategies.chat.adapter = "openrouter_claude";

# Disable a specific LSP server
plugins.lsp.servers.rust_analyzer.enable = false;
```

## Adding LuaSnip snippets

Extra snippet directories are **merged with** the built-in ones, so the base
snippets are always preserved:

```nix
imports = [ nixvim_config.nixosModules.default ];

nixvim-config.lsp.extraSnippetPaths = [ ./snippets ];
```

## Extending codecompanion adapters and prompts

`adapters` and `prompt_library` are attrsets, so new entries added downstream
are merged automatically. Existing entries (e.g. `chutes_ai`, `Ask
Mathematician`) can be replaced by assigning the same key.

```nix
imports = [ nixvim_config.nixosModules.default ];

# Add a new adapter
plugins.codecompanion.settings.adapters.work_llm = {
  __raw = ''
    function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          url     = "https://my-company.llm.internal";
          api_key = os.getenv("WORK_API_KEY");
          chat_url = "/v1/chat/completions",
        };
        schema.model.default = "gpt-4o";
      })
    end
  '';
};

# Add a new prompt
plugins.codecompanion.settings.prompt_library."Daily Standup" = {
  description = "Generate a standup update from recent git commits";
  strategy    = "chat";
  opts.short_name = "standup";
  prompts = [
    {
      role    = "user";
      content = "Summarise my recent commits into a standup update.";
    }
  ];
};

# Override an existing prompt
plugins.codecompanion.settings.prompt_library."Ask Mathematician" = {
  # ... replacement definition
};
```


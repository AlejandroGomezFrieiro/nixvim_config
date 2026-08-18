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

# Creative writing edition

A separate, deliberately minimal derivation for prose writing. It shares the
repo's base (overlay, colorscheme) but pulls in **no** plugins from
`./config` — it only enables what prose needs. Run it with:

```bash
nix run github:AlejandroGomezFrieiro/nixvim_config#writing
```

## Included (always on)

| Plugin | Purpose |
|---|---|
| treesitter | `markdown` + `markdown_inline` highlighting |
| render-markdown | in-buffer rendering of headings, bullets, code |
| bullets | auto-continue numbered/bulleted lists |
| goyo + twilight | distraction-free focus |
| markdown-oxide (LSP) | notes, links, tags, outlines |
| telescope | find files / grep / buffers / outline |
| blink.cmp | completion: LSP, path, buffers, spelling, dictionary |
| blink-cmp-spell / -dictionary | spelling fixes + project vocabulary autocomplete |
| luasnip | story snippets (`chapter`, `scene`, `char`, `place`, `item`, `beat`, `tonemeter`) |
| oil | file tree / binder-style navigation |
| which-key | keybinding discoverability |
| catppuccin | colorscheme |

Opening a `.md` file enters **writing mode**: word wrap, `linebreak`, spell
check, and prose-friendly indentation. With focus enabled, use `<leader>z` for
Goyo and `<leader>t` for Twilight when you want them; they do not interfere
with Oil or normal project navigation.

The writing build uses Oil for binder navigation. Both `<leader>e` and
`<leader>n` toggle a reusable left-side file-tree split; the latter matches the
main profile's familiar file-tree shortcut.

## Feature flags (`writing.*`)

| Option | Default | Controls |
|---|---|---|
| `writing.focus.enable` | `true` | Goyo + Twilight, available through focus mappings |
| `writing.grammar.enable` | `false` | LTeX (LanguageTool) grammar checking via LSP |
| `writing.vale.enable` | `false` | Vale prose linting via LSP (`vale-ls`) |
| `writing.markdownOxide.enable` | `true` | markdown-oxide LSP |
| `writing.preview.enable` | `true` | markdown-preview browser preview |
| `writing.export.enable` | `true` | pandoc + `:WritingExport` (DOCX) |
| `writing.dictionary.files` | bundled wordlist | dictionary completion sources |
| `writing.gitDrafts.enable` | `false` | fugitive + gitsigns + diffview draft workflow |
| `writing.storyteller.enable` | `false` | Storyteller project engine (enabled by the storytelling template) |

### Grammar checking (LTeX)

Enabled with `writing.grammar.enable = true`. Uses `ltex-ls` over LSP with
picky style rules. Add project dictionaries through LTeX settings as needed — see
<https://dzfrias.dev/blog/neovim-writing-setup/> for the approach.

Disabled via `nixosModules.writing` in a downstream flake:

```nix
imports = [ inputs.nixvim_config.nixosModules.writing ];
writing.grammar.enable = true;
writing.gitDrafts.enable = true;
```

### Prose linting (Vale)

Enabled with `writing.vale.enable = true`. Runs `vale-ls` (with the `vale`
CLI on `PATH`) alongside LTeX for style linting: **proselint**, **alex**,
**write-good**, and **readability** — the same default set as
[the setup described by Scott Lowe](https://blog.scottlowe.org/2024/07/29/using-vale-to-improve-my-writing/).

Vale needs a `.vale.ini` + `styles/` directory in a project root. A ready-made
bundle ships with this config; build it and copy it into your story project:

```bash
nix build github:AlejandroGomezFrieiro/nixvim_config#writing-vale
cp -r result/. /path/to/story-project/
```

The default `.vale.ini` lives at `writing/vale/.vale.ini` and applies the four
styles above to `*.md` files. Tweak it (or the bundled styles) per project, or
add project vocabulary as a Vale vocabulary under `styles/Vocab/<name>/`.

# Storytelling project template

`nix flake init -t github:AlejandroGomezFrieiro/nixvim_config#storytelling`
scaffolds a project with Storyteller enabled: outline beat sheets, reference
cards, chapter scaffolding, a treatment, project vocabulary, and a `justfile`.
Storyteller adds the project-aware layer: chapter outline, two-way
Scrivenings, reference detection, corkboard, collections, targets, snapshots,
and Pandoc manuscript export. See the template README or the
[Storyteller user guide](https://github.com/AlejandroGomezFrieiro/storytelling.nvim/blob/main/docs/user-guide.md)
for the workflow.

Both storytelling and a plain-prose sibling are available as templates, and
each ships with nix-direnv (`.envrc`) plus an auto-provisioned Vale setup
(LTeX grammar + Vale styles) turned on.

# Writing project template

`nix flake init -t github:AlejandroGomezFrieiro/nixvim_config#writing`
scaffolds a minimal plain-Markdown prose workspace (`manuscript/`, `notes/`,
`research/`, `words/`) with the same distraction-free Neovim prose environment
and prose linting (LTeX + Vale) as storytelling, but without the outline /
beat-sheet machinery — for essays, non-fiction, and novels that don't need
planning cards.

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
    pkgs = import nixpkgs {
      inherit system;
      # The base config enables blink-cmp-spell, the one non-free plugin.
      config.allowUnfreePredicate = pkg:
        builtins.elem (pkg.pname or pkg.name) [ "blink-cmp-spell" ];
    };
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

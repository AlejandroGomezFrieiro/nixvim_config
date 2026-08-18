# Storytelling

A low-friction writing environment for people who plan before they write.
Plays the role of a Scrivener / [Kindling](https://kindlingwriter.com/) binder
using plain Markdown + git + the `writing` Neovim build from
[nixvim_config](https://github.com/AlejandroGomezFrieiro/nixvim_config).

## Layout

```
.
├── outline/          # beat sheets and the story outline
│   ├── overview.md      <- your actual outline, top-level beats only
│   ├── three-act.md     <- Three-Act template
│   ├── heroes-journey.md<- Hero's Journey template
│   ├── save-the-cat.md  <- Save the Cat beat sheet template
│   └── story-circle.md  <- Dan Harmon's Story Circle template
├── references/       # the "corkboard" — entities with wikilinks
│   ├── characters/      # one file per character (char snippet expands a card)
│   ├── locations/       # places characters visit
│   ├── items/           # artifacts & objects in play
│   └── organizations/   # factions, guilds, families
├── chapters/         # prose, one file per chapter (chapter/scene snippets)
├── treatment/        # 1-page and 5-page treatments (outline in prose form)
├── research/         # anything you look up while writing
└── words/
    └── dictionary.txt  # project vocabulary, one word per line
```

## Quick start

```bash
nix develop          # enters the shell with Neovim + pandoc + just
just draft           # open Neovim at the outline
```

## Writing loop

1. **Plan** — pick a beat sheet in `outline/`, adapt it, and keep `overview.md`
   as the single source of truth for the outline. Reference entities by
   wiki-links (`[[Name]]`); markdown-oxide keeps hover/navigation working and
   Telescope shows the outline (`<leader>o`).
2. **Draft** — `just draft` drops you in Neovim. Opening any `.md` file
   auto-enters writing mode: word wrap, spell check, Twilight + Goyo so the
   page is all you see. Typing `chapter`, `scene`, `char`, `place`, `item`, or
   `beat` then `<Tab>` expands a card.
3. **Track** — `<leader>wc` word count, `<leader>mp` browser preview.
4. **Commit beats** — git snapshots per draft branch:
   ```
   git switch -c draft/act-2
   # ... write ...
   git merge owner/main
   ```
5. **Export** — `:WritingExport` (or `just export`) renders the current file
   to `build/<name>.docx` with pandoc.

## Commands

| Key       | Action                                |
|-----------|---------------------------------------|
| `<leader>ff` | find files                          |
| `<leader>fg` | grep the project                    |
| `<leader>o`  | document outline (headings)         |
| `<leader>e`  | oil file tree (binder navigation)   |
| `<leader>z`  | toggle Goyo (focus)                 |
| `<leader>t`  | toggle Twilight (dim inactive text) |
| `<leader>mp` | toggle live browser preview         |
| `<leader>wc` | word count                          |
| `<leader>ex` | export current file to DOCX         |

Completion: characters, places, and invented words autocomplete from the
bundled dictionary plus the words already in your buffers. To use *this
project's* `words/dictionary.txt` instead, override the writing module:

```nix
# in a custom flake that imports nixvim_config
module = {
  imports = [ inputs.nixvim_config.nixosModules.writing ];
  writing.dictionary.files = [ ./words/dictionary.txt ];
};
```

## Scrivener / Kindling features, mapped

| Feature          | Cheap replacement here                     |
|------------------|--------------------------------------------|
| Binder / corkboard | `references/` + `<leader>e` oil tree     |
| Outline drafts   | git branches (`draft/*`)                   |
| Beat sheets      | `outline/*.md` templates                   |
| Scene beats in prose | `scene` snippet + `- [ ]` checkboxes   |
| Word count/status| `<leader>wc`, `g <C-G>`                    |
| Export DOCX/EPUB | pandoc (`:WritingExport`)                 |
| Index cards      | per-scene reference files                  |
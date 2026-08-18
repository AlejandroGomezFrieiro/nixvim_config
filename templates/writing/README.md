# Writing

A minimal writing workspace: plain Markdown prose in Neovim with grammar and
style checks built in. Uses the `writing` build from
[nixvim_config](https://github.com/AlejandroGomezFrieiro/nixvim_config) with
the prose-linting stack switched on.

## Layout

```
.
├── manuscript/    # your prose, one file per chapter / essay
├── notes/         # working notes, outlines, ideas
├── research/      # source material and background
└── words/
    └── dictionary.txt  # project vocabulary, one word per line
```

## Quick start

```bash
nix develop          # enters the shell with Neovim + pandoc + just + vale
just draft           # open Neovim at the first manuscript chapter
```

Or with [nix-direnv](https://github.com/nix-community/nix-direnv) (`.envrc`
ships in this template):

```bash
direnv allow         # loads the same dev shell whenever you cd in
```

First `nix develop` (or `direnv allow`) provisions the bundled default Vale
config + styles into the project root (`.vale.ini` + `styles/`) so prose
linting is live immediately.

## Writing loop

1. **Draft** — `just draft` drops you in Neovim with word wrap and spell check.
   Use `<leader>z` for Goyo and `<leader>t` for Twilight when you want focus
   mode. Typing `chapter`, `scene`, and `beat` then `<Tab>` expands a card.
2. **Track** — `<leader>wc` word count, `<leader>mp` browser preview.
3. **Lint** — grammar (LTeX) and style (Vale) run as you type; `just lint`
   runs Vale across the manuscript from the shell.
4. **Export** — `:WritingExport` (or `just export`) renders the manuscript to
   `build/manuscript.docx` with pandoc.

## Prose linting

- **LTeX** (LanguageTool) catches grammar/spelling/picky style as you type.
- **Vale** runs `proselint`, `alex`, `write-good`, and `readability` —
  heuristics and curated word lists tuned for readable, inclusive prose.

Disable either in `flake.nix` (drop the `writing.grammar.enable` /
`writing.vale.enable` lines). Tune the rules in the project's `.vale.ini`,
and add project vocabulary to `words/dictionary.txt` (autocompletes) or a Vale
vocabulary under `styles/Vocab/<name>/`.

## Commands

| Key         | Action                              |
|-------------|-------------------------------------|
| `<leader>ff`| find files                          |
| `<leader>fg`| grep the project                    |
| `<leader>o` | document outline (headings)         |
| `<leader>e` | toggle left-side file tree         |
| `<C-h/j/k/l>`| move between splits               |
| `<A-h/j/k/l>`| resize splits                     |
| `gd`        | go to definition (LSP)              |
| `gr`        | references (LSP)                    |
| `<leader>l` | LSP + diagnostics                   |
| `<leader>z` | toggle Goyo (focus)                 |
| `<leader>t` | toggle Twilight (dim inactive text) |
| `<leader>mp`| toggle live browser preview         |
| `<leader>wc`| word count                          |
| `<leader>we`| export current file to DOCX         |
| `just lint`  | Vale lint all prose from the shell |

Completion: spelling fixes and project vocabulary autocomplete from
`words/dictionary.txt` plus the words already in your buffers. To use *this
project's* dictionary instead of the bundled one, override the writing module:

```nix
# in a custom flake that imports nixvim_config
module = {
  imports = [ inputs.nixvim_config.nixosModules.writing ];
  writing.dictionary.files = [ ./words/dictionary.txt ];
};
```

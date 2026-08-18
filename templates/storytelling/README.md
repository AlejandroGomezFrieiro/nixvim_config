# Storytelling Project Template

This template creates a Markdown-first writing project with the
`nixvim_config` writing environment and the
[`storyteller.nvim`](https://github.com/AlejandroGomezFrieiro/storytelling.nvim)
project engine.

## Start

```bash
nix flake init -t github:AlejandroGomezFrieiro/nixvim_config#storytelling
nix develop
just draft
```

`just draft` opens `outline/overview.md` in the writing Neovim build. The first
development-shell activation provides the configured Neovim, Pandoc, Just,
Vale, LTeX, Markdown Oxide, and Storyteller. The template pins Storyteller
directly, so its project commands do not depend on a future `nixvim_config`
release.

## Layout

```text
chapters/                  one Markdown file per chapter
references/characters/     character cards
references/locations/      location cards
references/items/          item cards
references/organizations/  organization cards
outline/                   overview and beat sheets
treatment/                 prose treatments
research/                  research notes
words/dictionary.txt       project vocabulary and names
```

The source of truth is the Markdown. `build/`, `progress.log`, and Vale's
generated configuration are derived or project-local support files.

## Responsibilities

The template provides the project layout, Neovim environment, snippets,
dictionary, Vale configuration, `just draft`, `just lint`, and an optional git
branch helper. Storyteller provides all story-aware behavior: outline and word
targets, Scrivenings, reference detection, corkboard, collections, sessions,
snapshots, templates, and export. This keeps one command surface authoritative
for each writing feature.

## Writing Workflow

1. Edit `outline/overview.md` or choose a structure with `:StoryTemplate`.
2. Draft in `chapters/`, using the `chapter` and `scene` snippets.
3. Use `<leader>n` for the file tree, `<leader>so` for the outline,
   `<leader>sb` for the corkboard, and `<leader>st` for targets.
4. Run `:StorySessionStart` and `:StorySessionEnd` when tracking a writing
   session.
5. Run `:StorySnapshot before-revision` before a structural rewrite.
6. Use `:StoryScrivenings` for continuous reading and two-way editing.
7. Export with `:StoryExport docx`, `:StoryExport epub`, or another supported
   format.

## Storyteller Commands

| Command | Purpose |
| --- | --- |
| `:StoryStatus` | Project totals and targets |
| `:StoryOutline` | Chapter outline and word counts |
| `:StoryScrivenings[!]` | Editable continuous manuscript |
| `:StoryMeta` | Edit current file's frontmatter |
| `:StoryDetect` | Detect references across the project |
| `:StoryDetectScene` | Detect references in the current scene |
| `:StoryReferences` | Browse reference cards |
| `:StoryCorkboard` | Review scene cards |
| `:StoryCollection` | Filter scenes for revision |
| `:StoryTargets` | Open targets dashboard |
| `:StorySnapshot [message]` | Create a safety snapshot |
| `:StoryTemplate` | Apply a story structure |
| `:StoryExport [format]` | Export the manuscript |

See the [Storyteller user guide](https://github.com/AlejandroGomezFrieiro/storytelling.nvim/blob/main/docs/user-guide.md)
for the complete `<leader>s` mapping table. The existing writing mappings for
focus mode, preview, file navigation, snippets, grammar, and Vale remain
unchanged.

## Metadata And References

Scenes can use inline fields compatible with the snippets:

```markdown
## Scene 1 — The harbor

- **POV:** Odysseus
- **Location:** Ithaca
- **Beat:** A warning arrives too late
```

Storyteller also understands frontmatter for status, planning state, targets,
tags, and links. Reference cards live in their type-specific directory; add a
`names:` list when a character has aliases. `:StoryDetectScene` can then add
links to the scene metadata.

Files and directories beginning with `_` are ignored. Use that convention for
unused scenes and reference templates.

## Prose Checking

The template enables both LTeX and Vale:

- LTeX provides LanguageTool grammar and style diagnostics in Neovim.
- Vale checks `outline/`, `chapters/`, and `treatment/` with
  `just lint`.

Disable either in `flake.nix` if it is not part of your workflow. Add names and
invented words to `words/dictionary.txt`.

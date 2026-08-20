# Storytelling Project Template

This template creates a Markdown-first writing project with the
`nixvim_config` writing environment and the
[`storyteller.nvim`](https://github.com/AlejandroGomezFrieiro/storytelling.nvim)
project engine. Storyteller is the project-aware layer; the Markdown files
remain the source of truth.

## Start

```bash
nix flake init -t github:AlejandroGomezFrieiro/nixvim_config#storytelling
nix develop
just draft
```

`just draft` opens `outline/overview.md` in the writing Neovim build. The
development shell provides the configured Neovim, Pandoc, Just, Vale, LTeX,
Storyteller, and the `storyteller-lsp` companion. The template pins Storyteller
directly and enables it through `writing.storyteller`, so the plugin and LSP
configuration stay in one module path.

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

`.storyteller` marks the root explicitly. The starter chapter and public-domain
Odysseus/Ithaca cards form a working example: open the chapter, run `:Story`,
`:Story corkboard`, `:Story timeline`, or `:Story detect`, then replace the
sample with your own story.

## Responsibilities

The template provides the project layout, Neovim environment, snippets,
dictionary, Vale configuration, `just draft`, `just lint`, and an optional git
branch helper. Storyteller provides all story-aware behavior: outline and word
targets, Scrivenings, reference detection, corkboard, collections, sessions,
snapshots, templates, and export. This keeps one command surface authoritative
for each writing feature.

## Writing Workflow

1. Edit `outline/overview.md` or preview a structure with `:Story template`.
2. Draft in `chapters/`, using the `chapter` and `scene` snippets.
3. Use `<leader>n` for the file tree, `<leader>so` for the outline,
   `<leader>sb` for the corkboard, and `<leader>st` for tracking.
4. Run `:Story session start` and `:Story session end` when tracking a writing
   session.
5. Run `:Story snapshot before-revision` before a structural rewrite.
6. Use `:Story compile` for continuous reading and two-way editing.
7. Export with `:Story export docx`, `:Story export epub`, or another supported
   format.

## Storyteller Commands

| Command | Purpose |
| --- | --- |
| `:Story` | Open the project dashboard |
| `:Story outline` | Review chapters, words, and targets |
| `:Story compile[!]` | Edit the continuous manuscript |
| `:Story corkboard` | Review scene cards |
| `:Story timeline` | Review scenes in story-time order |
| `:Story threads` | Follow plot setup and payoff |
| `:Story health` | Review loose ends and incomplete beats |
| `:Story meta` / `status` | Edit or cycle scene metadata |
| `:Story detect` | Detect and link references |
| `:Story references` | Browse reference cards |
| `:Story capture` | Create a reference card from a selection |
| `:Story track` | Review writing progress |
| `:Story session start` / `end` | Track a writing session |
| `:Story snapshot [message]` | Create a git safety snapshot |
| `:Story template` | Preview a story structure |
| `:Story export [format]` | Export the manuscript |
| `:Story idea` / `ideas` | Capture or review discovery ideas |

See the [Storyteller user guide](https://github.com/AlejandroGomezFrieiro/storytelling.nvim/blob/main/docs/user-guide.md)
for the complete `<leader>s` mapping table. Storyteller's language server is
inspired by markdown-oxide's Markdown navigation model, but provides its own
scene, reference-card, and story-project behavior. The existing writing
mappings for focus mode, preview, file navigation, snippets, grammar, and Vale
remain unchanged.

## Metadata And References

New scenes created by the `scene` snippet use a YAML block immediately after
the heading:

````markdown
## Scene 1 — The harbor

```yaml
storyteller: scene
status: draft
pov: Odysseus
location: Ithaca
beat: A warning arrives too late
```
````

Storyteller also understands chapter frontmatter for shared planning state,
targets, tags, and links. Reference cards live in their type-specific
directory; add a `names:` list when a character has aliases. `:Story detect` can
then add links to scene metadata.

## Snippets

The writing configuration ships both prose and Storyteller-specific snippets:

| Trigger | Creates |
| --- | --- |
| `chapter` | Chapter frontmatter, target, goals, and closing hook. |
| `scene` | A scene heading plus canonical `storyteller: scene` YAML. |
| `scenemeta` | Scene YAML block for an existing heading. |
| `char`, `place`, `item`, `org` | Reference card with detection aliases. |
| `idea` | A discovery task collected by `:Story ideas`. |
| `beat` | An outline checkbox. |

Files and directories beginning with `_` are ignored. Use that convention for
unused scenes and reference templates.

## Prose Checking

The template enables both LTeX and Vale:

- LTeX provides LanguageTool grammar and style diagnostics in Neovim.
- Vale checks `outline/`, `chapters/`, and `treatment/` with
  `just lint`.

Disable either in `flake.nix` if it is not part of your workflow. Add names and
invented words to `words/dictionary.txt`.

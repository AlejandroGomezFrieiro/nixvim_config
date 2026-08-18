local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("markdown", {
  -- Chapter card -----------------------------------------------------------
  s(
    "chapter",
    fmt(
      [[
---
type: chapter
status: {}
planning: {}
target: {}
---

# Chapter {}: {}

> Goal this chapter: {}
> Opens after: {}

## Scenes
- [ ] {}

## Closing hook
- [ ] {}
]],
      {
        i(1, "draft"), i(2, "flexible"), i(3, "5000"),
        i(4, "N"), i(5, "Title"), i(6, "protagonist wants ..."),
        i(7, "last chapter's outcome"), i(0, "scene 1"),
        i(8, "the gut-punch / cliffhanger"),
      }
    )
  ),

  -- Scene/beat card ---------------------------------------------------------
  s(
    "scene",
    fmt(
      [[
## Scene {} — {}

```yaml
storyteller: scene
status: {}
planning: {}
pov: {}
location: {}
time: {}
goal: {}
conflict: {}
outcome: {}
beat: {}
```

### Enter
{}

### Friction
- [ ] {}

### Leave
{}
]],
      {
        i(1, "N"),
        i(2, "Title"),
        i(3, "outline"),
        i(4, "flexible"),
        i(5, "character"),
        i(6, "place"),
        i(7, "day/time"),
        i(8, "scene goal"),
        i(9, "what blocks or twists the goal"),
        i(10, "what changes by the end"),
        i(11, "one-sentence emotional turn"),
        i(0, "strike a changed image / next domino to tip"),
        i(12, "what blocks or twists the goal"),
        i(13, "echo of the beat / new question"),
      }
    )
  ),

  -- Character reference -----------------------------------------------------
  s(
    "char",
    fmt(
      [[
---
names:
  - {}
---

## {} — {}

- **Role:** {}
- **Age / appearance:** {}
- **Core want:** {}
- **Core fear:** {}
- **Fatal flaw:** {}
- **Arc:** {}
- **Voice / tic:** {}
- **Relationships:** {}
- **Notes:**
  - {}
]],
      { rep(1), i(1, "Name"), i(2, "faction or epithet"), i(3, "role"), i(4, "appearance"), i(5, "want"), i(6, "fear"), i(7, "flaw"), i(8, "arc"), i(9, "voice"), i(10, "ties"), i(0, "who are they when no one watches") }
    )
  ),

  -- Location reference ------------------------------------------------------
  s(
    "place",
    fmt(
      [[
---
names:
  - {}
---

## {} — {}

- **Region / realm:** {}
- **Atmosphere:** {}
- **Sights / sounds / smells:** {}
- **Notable residents:** {}
- **Dramatic purpose:** {}
- **Notes:**
  - {}
]],
      { rep(1), i(1, "Name"), i(2, "tag"), i(3, "region"), i(4, "mood"), i(5, "sensory imprint"), i(6, "residents"), i(7, "what scenes happen here"), i(0, "odd detail that could pay off") }
    )
  ),

  -- Item / artifact ---------------------------------------------------------
  s(
    "item",
    fmt(
      [[
---
names:
  - {}
---

## {} — {}

- **Type:** {}
- **Wielder / owner:** {}
- **True power / lie it tells:** {}
- **Cost of use:** {}
- **History:** {}
- **Notes:**
  - {}
]],
      { rep(1), i(1, "Name"), i(2, "tag"), i(3, "artifact or object"), i(4, "owner"), i(5, "power"), i(6, "cost"), i(7, "history"), i(0, "what it means symbolically") }
    )
  ),

  -- Outline beat (beat-sheet friendly) --------------------------------------
  s(
    "beat",
    fmt(
      [[- [ ] **{}** — {}
]],
      { i(1, "Beat label"), i(0, "one-sentence what happens and its emotional punch") }
    )
  ),

  -- Storyteller scene metadata block ----------------------------------------
  s(
    "scenemeta",
    fmt(
      [[```yaml
storyteller: scene
status: {}
planning: {}
pov: {}
location: {}
time: {}
goal: {}
conflict: {}
outcome: {}
beat: {}
tags:
  - {}
```]],
      {
        i(1, "outline"), i(2, "flexible"), i(3, "character"),
        i(4, "place"), i(5, "day/time"), i(6, "scene goal"),
        i(7, "obstacle"), i(8, "change"), i(9, "emotional turn"),
        i(0, "act-1"),
      }
    )
  ),

  -- Discovery note, collected by :StoryDiscoveries -------------------------
  s("idea", fmt("- [ ] IDEA: {}", { i(0, "a possibility to revisit later") })),

  -- Organization reference --------------------------------------------------
  s(
    "org",
    fmt(
      [[---
names:
  - {}
---

## {} — {}

- **Type:** {}
- **Wants:** {}
- **Structure / ranks:** {}
- **Members:** {}
- **Conflict with:** {}
- **Notes:**
  - {}]],
      { rep(1), i(1, "Organization"), i(2, "faction or guild"), i(3, "type"), i(4, "collective goal"), i(5, "ranks"), i(6, "members"), i(7, "opposition"), i(0, "what the group hides") }
    )
  ),

  -- Title / tone meter ------------------------------------------------------
  s(
    "tonemeter",
    fmt(
      [[
## Tone meter

- Optimism ░░{}░░  Pessimism
- Trust ░░{}░░  Paranoia
- Prose ░░{}░░  Cuts
- Main plot ░░{}░░  Subplot
]],
      { i(1, "spaces"), i(2, "spaces"), i(3, "spaces"), i(0, "spaces") }
    )
  ),
})

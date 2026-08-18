local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("markdown", {
  -- Chapter card -----------------------------------------------------------
  s(
    "chapter",
    fmt(
      [[
# Chapter {}: {}

> Goal this chapter: {}
> Opens after: {}

## Scenes
- [ ] {}

## Closing hook
- [ ] {}
]],
      { i(1, "N"), i(2, "Title"), i(3, "protagonist wants ..."), i(4, "last chapter's outcome"), i(0, "scene 1"), i(5, "the gut-punch / cliffhanger") }
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
      { i(1, "Name"), i(2, "faction or epithet"), i(3, "role"), i(4, "appearance"), i(5, "want"), i(6, "fear"), i(7, "flaw"), i(8, "arc"), i(9, "voice"), i(10, "ties"), i(0, "who are they when no one watches") }
    )
  ),

  -- Location reference ------------------------------------------------------
  s(
    "place",
    fmt(
      [[
## {} — {}

- **Region / realm:** {}
- **Atmosphere:** {}
- **Sights / sounds / smells:** {}
- **Notable residents:** {}
- **Dramatic purpose:** {}
- **Notes:**
  - {}
]],
      { i(1, "Name"), i(2, "tag"), i(3, "region"), i(4, "mood"), i(5, "sensory imprint"), i(6, "residents"), i(7, "what scenes happen here"), i(0, "odd detail that could pay off") }
    )
  ),

  -- Item / artifact ---------------------------------------------------------
  s(
    "item",
    fmt(
      [[
## {} — {}

- **Type:** {}
- **Wielder / owner:** {}
- **True power / lie it tells:** {}
- **Cost of use:** {}
- **History:** {}
- **Notes:**
  - {}
]],
      { i(1, "Name"), i(2, "tag"), i(3, "artifact or object"), i(4, "owner"), i(5, "power"), i(6, "cost"), i(7, "history"), i(0, "what it means symbolically") }
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

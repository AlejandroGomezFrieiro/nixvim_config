local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("markdown", {
  -- Chapter card: plugin-required frontmatter plus the H1.
  s(
    "chapter",
    fmt(
      [[---
type: chapter
status: {}
planning: {}
target: {}
---

# Chapter {}: {}
]],
      {
        i(1, "draft"), i(2, "flexible"), i(3, "5000"),
        i(4, "N"), i(0, "Title"),
      }
    )
  ),

  -- Scene/beat card: heading plus the metadata block the plugin reads.
  s(
    "scene",
    fmt(
      [[## Scene {} — {}

```yaml
storyteller: scene
status: {}
pov: {}
location: {}
```
]],
      {
        i(1, "N"), i(2, "Title"),
        i(3, "outline"), i(4, "POV"), i(0, "where"),
      }
    )
  ),

  -- Character reference.
  s(
    "char",
    fmt(
      [[---
names:
  - {}
---

## {} — {}

{notes}
]],
      {
        rep(1), i(1, "Name"), i(2, "role"), i(0, "description"),
      }
    )
  ),

  -- Location reference.
  s(
    "place",
    fmt(
      [[---
names:
  - {}
---

## {} — {}

{notes}
]],
      {
        rep(1), i(1, "Name"), i(2, "tag"), i(0, "description"),
      }
    )
  ),

  -- Item / artifact reference.
  s(
    "item",
    fmt(
      [[---
names:
  - {}
---

## {} — {}

{notes}
]],
      {
        rep(1), i(1, "Name"), i(2, "tag"), i(0, "description"),
      }
    )
  ),

  -- Organization reference.
  s(
    "org",
    fmt(
      [[---
names:
  - {}
---

## {} — {}

{notes}
]],
      {
        rep(1), i(1, "Organization"), i(2, "faction or guild"), i(0, "description"),
      }
    )
  ),

  -- Outline beat (beat-sheet friendly).
  s(
    "beat",
    fmt(
      [[- [ ] **{}** — {}
]],
      { i(1, "Beat label"), i(0, "one-sentence what happens") }
    )
  ),
})
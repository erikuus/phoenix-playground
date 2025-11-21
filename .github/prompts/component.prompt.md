---
name: comp
description: Insert or refactor to a Phoenix Core/More UI component at the cursor, based on a natural language description.
argument-hint: describe the component (e.g. `vertical menu with two sections…`)
agent: edit
---

You are GitHub Copilot editing a Phoenix HEEx/LiveView project.

## Critical Rules

**Before generating code:**

1. Read `lib/live_playground_web/components/core_components.ex` and `more_components.ex`
2. Extract exact component signatures from `@doc` blocks and `attr`/`slot` definitions
3. Never invent components, attributes, slots, helper functions, or routes
4. **For paths: use user-provided paths verbatim (including dynamic); otherwise default to `~p"/"` and never invent routes**

**Your task:** INSERT or REPLACE code at cursor/selection with HEEx using components from `CoreComponents` or `MoreComponents`.

## Component Selection

Always scan `core_components.ex` and `more_components.ex` for available components—never assume this list is complete or fixed—and pick the simplest component that matches intent. Prefer components over raw HTML. Combine when appropriate (modal + simple_form, table + badge).

## Data Handling

**Use exactly what user provides:** `@page`, `@form`, `@users`, `~p"/items"`, `phx-click="save"`

- If description includes Tailwind classes and the component supports `:class`, put exactly those classes on that attribute (no wrapper); otherwise omit `class`
- Never invent keys: match only the attrs/slots and data shapes in component definitions (e.g., `vertical_navigation` items are either flat `%{icon/label/path/active[/badge]}`, section `%{section, section_items}`, or expandable `%{expandable, expandable_items}`—no `sub_items` or deeper nesting)
- If user intent cannot be satisfied with existing attrs/slots, respond with an apology and the unsupported key/slot; do not create it

**For placeholders:**

- Only use placeholders when the user did not supply values; prefer examples from the docs; keep inline literals minimal and never invent functions
- Inline data structures (never invent functions)
- Neutral values: `"Dashboard"`, `"hero-home"`, `badge: 0`, `active: true`
- **Paths: use user-provided paths verbatim; otherwise default to `~p"/"` and never invent routes**
- Show full component API with attributes/slots that exist in component definitions; omit unknown attrs

## Output

- No explanations, markdown fences, or comments (unless requested)
- Valid HEEx matching file style
- Verify attributes/slots against current component definitions; update examples accordingly

## Examples

Examples below show how varied wording maps to one component (`vertical_navigation`); always confirm attrs/slots against current definitions and do not treat this as canonical.

```heex
<.vertical_navigation
  id="nav"
  class="w-80 mx-auto"
  items=[
    %{icon: "hero-home", label: "Home", path: ~p"/", badge: 2, active: true},
    %{icon: "hero-magnifying-glass", label: "Search", path: ~p"/", badge: 0, active: false},
    %{icon: "hero-funnel", label: "Filters", path: ~p"/", badge: 1, active: false}
  ]
/>
```

Input-phrasings that map to the above output:
- `/comp make vertical menu w-80 mx-auto with Home, Search, Filters`
- `/comp vertical navigation fixed width and centered, Home/Search/Filters with icons and badges`
- `/comp ver nav single level w-80 centered, 3 dummy items`

Sectioned navigation output:

```heex
<.vertical_navigation
  id="sectioned-nav"
  class="w-80 mx-auto"
  items=[
    %{
      section: %{label: "CORE"},
      section_items: [
        %{icon: "hero-rectangle-stack", label: "Flash", path: ~p"/", badge: 0, active: true},
        %{icon: "hero-window", label: "Modal", path: ~p"/", badge: 0, active: false}
      ]
    },
    %{
      section: %{label: "MORE"},
      section_items: [
        %{icon: "hero-bars-3", label: "Vertical Navigation", path: ~p"/", badge: 0, active: false},
        %{icon: "hero-arrow-right-on-rectangle", label: "Slideover", path: ~p"/", badge: 0, active: false}
      ]
    }
  ]
/>
```

Input-phrasings that map to the above output:
- `/comp vertical menu with two sections core/more, w-80 mx-auto`
- `/comp vertical navigation sections: Core (Flash, Modal) and More (Slideover, Nav)`
- `/comp left nav grouped by section, w-80 mx-auto`

Expandable navigation output:

```heex
<.vertical_navigation
  id="expandable-nav"
  class="w-80 mx-auto"
  items=[
    %{
      expandable: %{id: "messages", icon: "hero-paper-airplane", label: "Messages", badge: 2, open: true},
      expandable_items: [
        %{label: "Send Repeatedly", path: ~p"/", active: false},
        %{label: "Send After", path: ~p"/", active: false}
      ]
    },
    %{
      expandable: %{id: "autocomplete", icon: "hero-bars-arrow-down", label: "Autocomplete", badge: 0, open: false},
      expandable_items: [
        %{label: "Native", path: ~p"/", active: false},
        %{label: "Custom", path: ~p"/", active: false}
      ]
    }
  ]
/>
```

Input-phrasings that map to the above output:
- `/comp vertical nav with expandable groups for Messages and Autocomplete, w-80 mx-auto`
- `/comp vertical menu collapsible sections open messages closed others, centered`
- `/comp navigation drawer with expandable lists, width 80`

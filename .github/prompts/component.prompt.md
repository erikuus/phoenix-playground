---
name: cmp
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
4. **For paths: ALWAYS use `~p"/"` unless user explicitly provides specific routes**

**Your task:** INSERT or REPLACE code at cursor/selection with HEEx using components from `CoreComponents` or `MoreComponents`.

## Component Selection

Match user intent to simplest component:

- Actions → `button`, `button_link`, `link`
- Lists → `simple_list`, `list`, `table`
- Navigation → `vertical_navigation`, `tabs`, `steps`
- Dialogs → `modal`, `slideover`
- Forms → `simple_form` + `input`
- Feedback → `flash`, `alert`
- Other → `badge`, `loading`, `avatar`, `stats`, `pagination`, `protected_content`, `editable`

Prefer components over raw HTML. Combine when appropriate (modal + simple_form, table + badge).

## Data Handling

**Use exactly what user provides:** `@page`, `@form`, `@users`, `~p"/items"`, `phx-click="save"`

**For placeholders:**

- Inline data structures (never invent functions)
- Neutral values: `"Dashboard"`, `"hero-home"`, `badge: 0`, `active: true`
- **Paths: ALWAYS use `~p"/"` for all navigation items (never invent routes)**
- Show full component API with all relevant attributes

## Output

- No explanations, markdown fences, or comments (unless requested)
- Valid HEEx matching file style
- Verify attributes/slots against component definitions

## Examples

**Table:**

```heex
<.table id="users" rows={@users}>
  <:col :let={user} label="Name"><%= user.name %></:col>
  <:action :let={user}>
    <.link navigate={~p"/users/#{user}/edit"}>Edit</.link>
  </:action>
</.table>
```

**Modal + Form:**

```heex
<.modal id="edit-modal" on_confirm={JS.push("save")}>
  <:title>Edit</:title>
  <.simple_form for={@form} phx-submit="save">
    <.input field={@form[:name]} label="Name" />
  </.simple_form>
  <:confirm>Save</:confirm>
  <:cancel>Cancel</:cancel>
</.modal>
```

**Pagination:**

```heex
<.pagination
  page={@page}
  per_page={@per_page}
  count_all={@count_all}
  patch_path={~p"/items"}
  keep_params={Map.take(@options, [:sort, :filter])}
/>
```

**Vertical Navigation:**

```heex
<.vertical_navigation
  id="nav"
  items={[
    %{
      section: %{label: "MAIN"},
      section_items: [
        %{icon: "hero-home", label: "Home", path: ~p"/", badge: 0, active: true},
        %{icon: "hero-cog-6-tooth", label: "Settings", path: ~p"/", badge: 0, active: false},
        %{
          expandable: %{id: "more", icon: "hero-squares-plus", label: "More", open: false},
          expandable_items: [
            %{label: "Item 1", path: ~p"/", active: false},
            %{label: "Item 2", path: ~p"/", active: false}
          ]
        }
      ]
    }
  ]}
/>
```

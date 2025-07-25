---
applyTo: "**/*.ex"
description: "LiveView coding conventions and quality guidelines."
---

This file defines the coding conventions that MUST be followed when writing or modifying LiveView code. These conventions ensure consistency and maintainability across the codebase.

## Core Principles

### The Stepdown Rule

ALWAYS organize functions in a top-down manner, where each function is followed by the functions it calls. This rule is MANDATORY because it:

- Makes code breakdowns easy to read top-to-bottom
- Creates a natural flow through the code
- Helps maintain clear dependencies between functions

## Module Structure

### Function Ordering Convention

You MUST order functions in LiveView modules as follows:

1. Documentation and Imports at the top

   - Module documentation
   - All imports and aliases

2. `mount/3` function

   - Place ALL helpers it uses directly after it
   - NO other functions should come between mount and its helpers

3. `handle_params/3` function

   - Place ALL helpers it uses directly after it
   - For helpers shared with `mount`, place after the highest-level function that uses them
   - For helpers shared between other helpers, place after the highest-level function that uses them

4. `render/1` function (if present)

   - MUST come after mount/handle_params and before event handlers
   - Functional components called by `render/1` MUST be placed immediately after `render/1` following the stepdown rule

5. `handle_event/3` function

6. `handle_info/2` function

7. Helper functions for `render`, `handle_event`, and `handle_info`
   - MUST be placed at the end
   - Group helpers with their main function
   - NOTE: This applies only to helper functions, NOT functional components. Functional components follow the stepdown rule and are placed immediately after their caller.

## State Management

### Ordering `assign` and `stream` Calls

You MUST update core UI-related state BEFORE handling data streams. This rule exists because:

- Ensures assigned values are up-to-date before stream updates
- Prevents race conditions in state updates

CORRECT:

```elixir
# First update UI state, then handle streams
socket
|> assign(:options, options)
|> stream(:data, items, reset: true)
```

INCORRECT:

```elixir
# Don't handle streams before UI state
socket
|> stream(:data, items, reset: true)
|> assign(:options, options)
```

### Ordering `put_flash` and `stream` Calls

Flash messages (`put_flash`) are considered UI feedback operations and MUST come AFTER stream operations, not before. This is because:

- Flash messages provide feedback about the result of data operations
- Stream operations modify the actual data being displayed
- The logical flow is: update data → provide feedback about the update

CORRECT:

```elixir
# First handle stream, then provide feedback
socket
|> stream_insert(:cities, city)
|> put_flash(:info, "City successfully updated.")
```

INCORRECT:

```elixir
# Don't provide feedback before handling stream
socket
|> put_flash(:info, "City successfully updated.")
|> stream_insert(:cities, city)
```

### Code Style for State Updates

1. For multiple variables or complex logic, you MUST use expanded form:

```elixir
# DO use expanded form for complex operations
data = fetch_data(params)
count = count_items(data)

socket =
  socket
  |> assign(:count, count)
  |> assign(:data, data)
```

2. For single variable or straightforward logic, you MUST use concise form:

```elixir
# DO use concise form for simple operations
socket
|> assign(:data, fetch_data(params))
```

## Function Naming

### Helper Function Categories

1. State-Manipulating Functions (returning `socket`)

   - MUST use action-oriented verbs
   - DO use: `init`, `apply_options`, `apply_action`
   - DON'T use: `options`, `data`, `setup`

2. Data Transformation Functions (modifying variables or data structures)

   - MUST use verbs indicating the transformation
   - DO use: `update_params`, `to_integer`
   - DON'T use: `params`, `integer`

3. Value-Retrieving Functions
   - MUST use the `get_` prefix
   - DO use: `get_existing_page`, `get_pagination_url`
   - DON'T use: `existing_page`, `pagination_url`

## Message Handling

### Phoenix PubSub Message Structure

You MUST structure ALL broadcasted messages as a tuple containing:

1. The module name (`__MODULE__`)
2. A tuple of event and resource

CORRECT:

```elixir
# DO structure messages this way
{__MODULE__, {event, resource}}
```

INCORRECT:

```elixir
# DON'T structure messages these ways
{event, resource}  # Missing module name
{__MODULE__, event, resource}  # Wrong tuple structure
```

## Error Handling

### Phoenix Context Functions with !

When using Phoenix context functions that end with ! (like Cities.get_city!), you MUST NOT add additional error handling for expected failure cases.

Functions ending with ! are designed to:

Raise exceptions for expected error cases (like "not found")
Let Phoenix automatically handle these exceptions
Return appropriate HTTP responses (like 404) without additional code

CORRECT:

```elixir
# DO let Phoenix handle the exception
defp apply_action(%{"id" => id}, :edit, socket) do
  city = Cities.get_city!(id)  # Phoenix handles the 404 if not found

  socket
  |> assign(:city, city)
  |> assign(:form, get_city_form(city))
end
```

INCORRECT:

```elixir
# DON'T add unnecessary error handling
defp apply_action(%{"id" => id}, :edit, socket) do
  case Cities.get_city(id) do
    {:ok, city} ->
      socket
      |> assign(:city, city)
      |> assign(:form, get_city_form(city))

    {:error, :not_found} ->
      socket
      |> put_flash(:error, "City not found.")
      |> push_patch(to: ~p"/cities")
  end
end
```

Rule: If Phoenix's default error handling (like returning a 404 page) is sufficient, use the ! version and let Phoenix handle it automatically.

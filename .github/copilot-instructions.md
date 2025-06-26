# LiveView Coding Conventions

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

5. `handle_event/3` function

6. `handle_info/2` function

7. Helper functions for `render`, `handle_event`, and `handle_info`
   - MUST be placed at the end
   - Group helpers with their main function

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

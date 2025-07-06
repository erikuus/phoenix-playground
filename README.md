# Phoenix LiveView Playground

A collection of Phoenix LiveView patterns, components, and tutorials demonstrating various implementation approaches and common use cases.

## Getting Started

```bash
git clone https://github.com/erikuus/phoenix-playground.git
cd phoenix-playground
mix setup
mix phx.server
```

Visit [localhost:4000](http://localhost:4000) to explore the examples.

## What's Included

This repository contains three main sections:

- **Recipes** - Practical examples covering core LiveView concepts and common patterns
- **Components** - A collection of reusable UI components with different variations
- **Step-by-Step Tutorials** - Progressive guides for building advanced CRUD interfaces

## Recipes

The recipes section demonstrates fundamental LiveView concepts through working examples:

**Framework Concepts:**

- Event handling (click, change, key events)
- URL parameter processing and navigation
- Process messaging and timing patterns
- Stream management and real-time updates
- Broadcasting and PubSub integration
- JavaScript hooks and client-server communication

**Common Patterns:**

- Search and autocomplete implementations
- Filtering and sorting strategies
- Pagination approaches
- Form handling and validation
- File upload patterns (local and cloud storage)
- Data entry workflows

## Components

A library of UI components that can be adapted for different applications:

**Layout & Navigation:**

- Multi-column responsive layouts
- Sidebar navigation with sections
- Vertical navigation with expandable sections
- Header components with various configurations

**Interactive Elements:**

- Modal dialogs with different styles and behaviors
- Slideover panels with scroll handling
- Tables with sorting, actions, and stream support
- Pagination components with various options
- Form inputs with validation states
- Flash messages and alerts

**Specialized Components:**

- File upload areas with preview functionality
- Progress indicators and loading states
- Editable inline components
- Statistics displays
- Tab navigation systems

## Step-by-Step Tutorials

These tutorials demonstrate how to build sophisticated CRUD interfaces by progressively adding features:

1. **Generated Foundation** - Starting with Phoenix generators
2. **Add Pagination** - Implementing pagination with real-time updates
3. **Extract Helpers** - Creating reusable helper modules
4. **Add Sorting** - Building sortable columns with visual indicators
5. **Add Filtering** - Implementing search and filtering capabilities

The tutorials also cover advanced patterns like:

- Real-time updates with conflict resolution
- Optimistic locking for concurrent edits
- State management across multiple users
- Helper module architecture for reusability

## Helper Modules

The playground includes helper modules that can be used in other projects:

- **PaginationHelpers** - Handle pagination logic and URL parameter management
- **SortingHelpers** - Manage column sorting with proper state handling
- **FilteringHelpers** - Process search and filter criteria

## Architecture Notes

The examples follow current Phoenix and LiveView conventions:

- Uses Phoenix 1.7+ patterns
- Implements Phoenix.Component for reusable UI
- Demonstrates proper stream management
- Shows PubSub integration patterns
- Includes JavaScript integration examples

Some examples intentionally demonstrate advanced scenarios like handling multiple concurrent users, which may be more complex than needed for typical applications.

## Requirements

- Elixir ~> 1.14
- Phoenix ~> 1.7.11
- Phoenix LiveView ~> 1.0.0
- PostgreSQL (for database examples)

## Contributing

Suggestions for additional patterns or improvements to existing examples are welcome.

## Learn More

- [Phoenix LiveView Documentation](https://hexdocs.pm/phoenix_live_view)
- [Phoenix Framework](https://www.phoenixframework.org/)
- [Elixir Forum - Phoenix](https://elixirforum.com/c/phoenix-forum)

defmodule LivePlaygroundWeb.StepsLive.Index do
  use LivePlaygroundWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="mb-6">
      Introduction
      <:subtitle>
        A step-by-step guide to building advanced LiveView CRUD with reusable helpers
      </:subtitle>
    </.header>

    <div class="prose">
      <h3><strong>What We're Building</strong></h3>

      <p>
        This tutorial demonstrates how to build a sophisticated CRUD interface using Phoenix LiveView,
        progressing from basic generated code to a fully-featured system with pagination, sorting,
        and filtering.
      </p>

      <p>
        You'll learn to create three reusable helper modules that work together seamlessly:
      </p>

      <ul>
        <li><strong>PaginationHelpers</strong> - Handle page navigation and item counts</li>
        <li><strong>SortingHelpers</strong> - Manage column sorting with visual indicators</li>
        <li><strong>FilteringHelpers</strong> - Process search and filter criteria</li>
      </ul>

      <h4><strong>The Tutorial Progression</strong></h4>

      <p>
        Each step builds upon the previous one:
      </p>

      <ol>
        <li><strong>Generate Foundation:</strong> Start with basic Phoenix LiveView generated code</li>
        <li><strong>Implement Pagination:</strong> Add advanced pagination with real-time updates</li>
        <li><strong>Extract Pagination Helper:</strong> Refactor into reusable helper module</li>
        <li><strong>Add Sorting Helper:</strong> Implement column sorting using the same pattern</li>
        <li><strong>Add Filtering Helper:</strong> Complete the system with search and filtering</li>
      </ol>

      <h4><strong>Intentionally Ambitious Approach</strong></h4>

      <p>
        We've chosen an intentionally ambitious UX strategy that handles scenarios where
        many users are updating the same table simultaneously. This approach demonstrates advanced
        LiveView patterns including:
      </p>

      <ul>
        <li>Real-time updates with conflict resolution</li>
        <li>Optimistic locking for concurrent edits</li>
        <li>Sophisticated state management across multiple users</li>
        <li>Clear visual feedback for all user actions</li>
      </ul>

      <p>
        <strong>This level of sophistication is overkill for most applications.</strong> The goal is to
        learn these advanced patterns so you can apply them appropriately when your requirements
        actually demand this complexity.
      </p>
    </div>
    """
  end
end

defmodule LivePlaygroundWeb.GridLive.Index do
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
        <li><strong>Generate baseline CRUD:</strong> Use <code>mix phx.gen.live</code></li>
        <li><strong>Implement Pagination:</strong> Add advanced pagination with real-time updates</li>
        <li><strong>Extract Pagination Helper:</strong> Refactor pagination into reusable helper module</li>
        <li><strong>Add Sorting Helper:</strong> Implement column sorting using the same pattern</li>
        <li><strong>Add Filtering Helper:</strong> Complete the system with filtering</li>
      </ol>

      <h4><strong>Intentionally Ambitious Approach</strong></h4>

      <p>
        We've chosen an intentionally ambitious implementation that goes beyond basic CRUD.
        Along the way you'll learn how to:
      </p>

      <ul>
        <li>
          <strong>URL State Management:</strong>
          Keep pagination, sorting, and filtering in URL query strings, with validation that ensures even manually-edited or invalid URLs display valid pages
        </li>
        <li>
          <strong>Efficient DOM Updates:</strong>
          Update tables efficiently so that when one row is inserted, updated, or deleted, only that specific row's DOM changes while the rest of the page remains untouched
        </li>
        <li>
          <strong>Real-time Broadcasting:</strong>
          Broadcast database changes so that when a record changes in one browser, other open browsers update their tables automatically without full page reloads
        </li>
        <li>
          <strong>Concurrent Edit Detection:</strong>
          Handle concurrent edits by detecting when someone else has modified a record after you opened the form, showing a clear message, reloading the latest data, and allowing you to retry
        </li>
        <li>
          <strong>Contextual User Feedback:</strong>
          Display contextual flash messages that adapt to what users see: your own actions versus others' actions (create, update, delete) generate different messages depending on whether the record appears on your current page; deleted rows remain visible but greyed out with strikethrough; and a "reload and sort now" link lets users deliberately refresh counts and pagination without sudden jumps or page changes
        </li>
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

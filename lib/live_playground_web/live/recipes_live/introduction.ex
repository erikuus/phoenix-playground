defmodule LivePlaygroundWeb.RecipesLive.Introduction do
  use LivePlaygroundWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header class="mb-6">
      Phoenix LiveView Recipes
      <:subtitle>
        Practical code examples covering core LiveView features and common UI patterns
      </:subtitle>
    </.header>
    <div class="flex flex-col gap-x-0 gap-y-8 xl:flex-row xl:gap-x-10 xl:gap-y-0">
      <div class="flex-1 prose max-w-none rounded-lg bg-zinc-100 p-6">
        <h3>Core LiveView Features</h3>
        <p>
          Essential LiveView capabilities with practical examples showing real-world implementations.
        </p>
        <ul>
          <li>Event handling (click, change, key events)</li>
          <li>URL parameter processing</li>
          <li>Process messaging and timing</li>
          <li>Stream management</li>
          <li>Real-time broadcasting</li>
          <li>JavaScript integration</li>
        </ul>
      </div>
      <div class="flex-1 prose max-w-none rounded-lg bg-zinc-100 p-6">
        <h3>Common UI Patterns</h3>
        <p>
          Frequently needed user interface patterns and data handling workflows.
        </p>
        <ul>
          <li>Search and autocomplete</li>
          <li>Filtering and sorting</li>
          <li>Pagination strategies</li>
          <li>Form handling and validation</li>
          <li>File upload patterns</li>
          <li>Data entry workflows</li>
        </ul>
      </div>
    </div>
    <div class="mt-10 prose max-w-none">
      <h3>How to Use These Recipes</h3>
      <p>
        Each recipe is self-contained and includes working code you can experiment with directly.
        The recipes vary in complexity - some are beginner-friendly while others demonstrate advanced techniques.
      </p>
      <p>
        <strong>Core LiveView Features</strong>
        focuses on platform capabilities like event handling, streams, and JavaScript integration. <strong>Common UI Patterns</strong>
        shows practical solutions for search, forms, pagination, and data workflows.
      </p>
      <p>
        Browse freely based on your current needs. The patterns shown can be adapted and combined
        based on your application's specific requirements.
      </p>
    </div>
    """
  end
end

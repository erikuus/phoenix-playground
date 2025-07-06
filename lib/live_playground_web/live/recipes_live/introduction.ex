defmodule LivePlaygroundWeb.RecipesLive.Introduction do
  use LivePlaygroundWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header class="mb-6">
      Phoenix LiveView Recipes
      <:subtitle>
        Practical code examples organized by framework concepts and implementation patterns
      </:subtitle>
    </.header>
    <div class="flex flex-col gap-x-0 gap-y-8 xl:flex-row xl:gap-x-10 xl:gap-y-0">
      <div class="flex-1 prose max-w-none rounded-md bg-gray-100 p-6">
        <h3>Framework Concepts</h3>
        <p>
          Core LiveView mechanics and framework features that form the foundation of all LiveView applications.
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
      <div class="flex-1 prose max-w-none rounded-md bg-gray-100 p-6">
        <h3>Practical Patterns</h3>
        <p>
          Common implementation patterns and solutions you'll frequently need in real applications.
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
      <h3>Learning Path</h3>
      <p>
        If you're new to LiveView, start with the <strong>Framework Concepts</strong>
        section to understand
        the core mechanics. Once comfortable with event handling and basic patterns, explore the <strong>Practical Patterns</strong>
        section to see how these concepts combine into real-world solutions.
      </p>
      <p>
        Each recipe is self-contained and includes working code you can experiment with directly.
        The patterns shown can be adapted and combined based on your application's specific requirements.
      </p>
    </div>
    """
  end
end

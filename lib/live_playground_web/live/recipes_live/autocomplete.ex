defmodule LivePlaygroundWeb.RecipesLive.Autocomplete do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :matches, [])}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Native Autocomplete
      <:subtitle>
        Creating an Autocomplete Field With HTML5 Datalist in LiveView
      </:subtitle>
      <:actions>
        <.code_breakdown_link />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form>
      <div class="w-full md:w-96">
        <.input
          phx-change="suggest"
          phx-debounce="500"
          type="text"
          name="query"
          list="matches"
          autocomplete="off"
          placeholder="Country"
          value=""
        />
      </div>
    </form>
    <datalist id="matches">
      <option :for={match <- @matches} value={match.name} />
    </datalist>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/autocomplete.ex" />
      <.code_block filename="lib/live_playground/countries.ex" from="# search" to="# endsearch" />
    </div>
    <.code_breakdown_slideover filename="priv/static/html/autocomplete.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("suggest", %{"query" => query}, socket) when query == "" do
    {:noreply, assign(socket, :matches, [])}
  end

  def handle_event("suggest", %{"query" => query}, socket) do
    {:noreply, assign(socket, :matches, Countries.list_country(query))}
  end
end

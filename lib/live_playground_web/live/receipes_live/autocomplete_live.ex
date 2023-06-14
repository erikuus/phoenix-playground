defmodule LivePlaygroundWeb.AutocompleteLive do
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
        How to create autocomplete field in LiveView using native HTML5 input list attribute and datalist element
      </:subtitle>
      <:actions>
        <.link navigate={~p"/autocomplete-custom"}>
          See also: Custom Autocomplete <.icon name="hero-arrow-long-right" class="ml-1 h-5 w-5 text-gray-400" />
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form>
      <div class="md:w-96">
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
      <%= raw(code("lib/live_playground_web/live/receipes_live/autocomplete_live.ex")) %>
      <%= raw(code("lib/live_playground/countries.ex", "# search", "# endsearch")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("suggest", %{"query" => query}, socket) do
    {:noreply, assign(socket, :matches, Countries.list_country(query))}
  end
end

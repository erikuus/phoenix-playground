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
      Autocomplete
      <:subtitle>
        How to handle autocomplete in live view
      </:subtitle>
      <:actions>
        <.link navigate={~p"/autocomplete-advanced"}>
          Try advanced autocomplete
        </.link>
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form>
      <div class="w-96">
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
      <%= raw(code("lib/live_playground_web/live/autocomplete_live.ex")) %>
      <%= raw(code("lib/live_playground/countries.ex", "# search", "# endsearch")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("suggest", %{"query" => query}, socket) do
    {:noreply, assign(socket, :matches, Countries.list_country(query))}
  end
end

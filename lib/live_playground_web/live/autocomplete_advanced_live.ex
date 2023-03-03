defmodule LivePlaygroundWeb.AutocompleteAdvancedLive do
  use LivePlaygroundWeb, :live_view

  import LivePlaygroundWeb.UiComponent

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        query: nil,
        matches: []
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.heading>
      Advanced Autocomplete
      <:footer>
        How to handle autocomplete in live view using custom datalist
      </:footer>
      <:buttons>
        <.button navigate="/autocomplete" color={:secondary}>
          Back to simple autocomplete
        </.button>
      </:buttons>
    </.heading>
    <!-- end hiding from live code -->
    <form>
      <.input
        value={@query}
        phx-change="suggest"
        phx-debounce="500"
        type="text"
        name="query"
        autocomplete="off"
        placeholder="Country"
        class="w-96" />
    </form>
    <.datalist :if={@matches != []} class="max-h-64 w-96">
      <.option :for={match <- @matches} phx-click="select" phx-value-name={match.name}>
        <div class="flex justify-between items-center">
          <span class="w-56 truncate font-medium"><%= match.name %></span>
          <span class="text-xs"><%= match.code %></span>
          <span class="text-xs"><%= match.code2 %></span>
        </div>
      </.option>
    </.datalist>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/autocomplete_advanced_live.ex")) %>
      <%= raw(code("lib/live_playground/countries.ex", "# search", "# endsearch")) %>
    </div>
    <!-- end hiding from live code -->
    """
  end

  def handle_event("suggest", %{"query" => query}, socket) do
    socket =
      assign(socket,
        query: query,
        matches: Countries.list_country(query)
      )

    {:noreply, socket}
  end

  def handle_event("select", %{"name" => name}, socket) do
    socket =
      assign(socket,
        query: name,
        matches: []
      )

    {:noreply, socket}
  end

  def handle_event("close", _, socket) do
    {:noreply, assign(socket, :matches, [])}
  end
end

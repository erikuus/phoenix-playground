defmodule LivePlaygroundWeb.ReceipesLive.AutocompleteCustom do
  use LivePlaygroundWeb, :live_view

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
    <.header class="mb-6">
      Custom Autocomplete
      <:subtitle>
        How to create autocomplete field in LiveView using custom dropdown and option components
      </:subtitle>
      <:actions>
        <.link navigate={~p"/autocomplete"}>
          <.icon name="hero-arrow-long-left" class="mr-1 h-5 w-5 text-gray-400" /> Back to: Native Autocomplete
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
          autocomplete="off"
          placeholder="Country"
          value={@query}
        />
      </div>
    </form>
    <.dropdown :if={@matches != []} class="max-h-64 md:w-96">
      <.option :for={match <- @matches} phx-click="select" phx-value-name={match.name}>
        <div class="flex justify-between items-center">
          <span class="w-56 truncate font-medium"><%= match.name %></span>
          <span class="hidden md:inline text-xs"><%= match.code %></span>
          <span class="hidden md:inline text-xs"><%= match.code2 %></span>
        </div>
      </.option>
    </.dropdown>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <%= raw(code("lib/live_playground_web/live/receipes_live/autocomplete_custom.ex")) %>
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

defmodule LivePlaygroundWeb.RecipesLive.AutocompleteCustom do
  use LivePlaygroundWeb, :live_view

  alias LivePlayground.Countries

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:query, nil)
      |> assign(:matches, [])

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- start hiding from live code -->
    <.header class="mb-6">
      Custom Autocomplete
      <:subtitle>
        Creating a Custom Dropdown Autocomplete in LiveView
      </:subtitle>
      <:actions>
        <.slideout_link slideout_id="code-breakdown" title="Code Breakdown" />
      </:actions>
    </.header>
    <!-- end hiding from live code -->
    <form>
      <div class="w-full md:w-96">
        <.input
          id="autocomplete-field"
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

    <ul
      :if={@matches != []}
      phx-click-away="close"
      class="absolute z-10 mt-1 overflow-auto rounded-md shadow-lg border border-gray-200 bg-white py-1 block max-h-64 md:w-96"
    >
      <li
        :for={match <- @matches}
        phx-click="select"
        phx-value-name={match.name}
        class="relative cursor-default select-none hover:bg-zinc-700 hover:text-white py-2 pl-3 pr-9"
      >
        <div class="flex justify-between items-center">
          <span class="w-56 truncate font-medium">{match.name}</span>
          <span class="hidden md:inline text-xs">{match.code}</span>
          <span class="hidden md:inline text-xs">{match.code2}</span>
        </div>
      </li>
    </ul>
    <!-- start hiding from live code -->
    <div class="mt-10 space-y-6">
      <.code_block filename="lib/live_playground_web/live/recipes_live/autocomplete_custom.ex" />
      <.code_block filename="lib/live_playground/countries.ex" from="# search" to="# endsearch" />
    </div>
    <.slideout title="Code Breakdown" id="code-breakdown" filename="priv/static/html/recipes/autocomplete_custom.html" />
    <!-- end hiding from live code -->
    """
  end

  def handle_event("suggest", %{"query" => query}, socket) when query == "" do
    {:noreply, assign(socket, :matches, [])}
  end

  def handle_event("suggest", %{"query" => query}, socket) do
    socket =
      socket
      |> assign(:query, query)
      |> assign(:matches, Countries.list_country(query))

    {:noreply, socket}
  end

  def handle_event("select", %{"name" => name}, socket) do
    socket =
      socket
      |> assign(:query, name)
      |> assign(:matches, [])

    {:noreply, socket}
  end

  def handle_event("close", _, socket) do
    {:noreply, assign(socket, :matches, [])}
  end
end
